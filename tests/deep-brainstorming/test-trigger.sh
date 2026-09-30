#!/usr/bin/env bash
# Opt-in headless trigger test for skills/deep-brainstorming.
#
# Runs real `claude -p` sessions (costs API calls) against a small fixture
# project and checks, from stream-json output only, which skills were
# invoked and which files were written. Prose is never asserted on.
#
# Usage:
#   tests/deep-brainstorming/test-trigger.sh [--reps N] [--only CASE]
#                                            [--plugin-dir PATH] [--max-turns N]
#
#   --reps N          runs per prompt (default 3)
#   --only CASE       all (default), a kind (positive | borderline |
#                     negative), or one case name such as csv-export
#   --plugin-dir PATH plugin to load (default: this repo). Point it at a
#                     checkout of another branch to record a baseline.
#   --max-turns N     turn cap per run (default 15)
#
# Thresholds:
#   positive   "Let's make a react todo list": deep-brainstorming (directly
#              or through brainstorming), no writes outside
#              docs/superpowers/specs/, in every run
#   borderline new features on existing pages, including one that already
#              states outcome, scope, constraints and acceptance criteria,
#              reach deep-brainstorming in at least 2 of 3 runs (scaled
#              to --reps)
#   negative   a bounded flag addition never reaches deep-brainstorming
set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPS=3
ONLY=all
MAX_TURNS=15
RUN_TIMEOUT=420
# Explicit allow-list instead of --dangerously-skip-permissions, which
# refuses to run as root. Denied tools show up in the log, not as a hang.
ALLOWED_TOOLS="Skill Read Glob Grep Write Edit WebSearch WebFetch TodoWrite TaskCreate TaskUpdate Agent Task Bash(ls:*) Bash(git log:*) Bash(git status:*) Bash(cat:*)"

while [ $# -gt 0 ]; do
  case "$1" in
    --reps) REPS="$2"; shift 2 ;;
    --only) ONLY="$2"; shift 2 ;;
    --plugin-dir) PLUGIN_DIR="$(cd "$2" && pwd)"; shift 2 ;;
    --max-turns) MAX_TURNS="$2"; shift 2 ;;
    -h|--help) sed -n '2,24p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

command -v claude >/dev/null 2>&1 || { echo "claude CLI not found" >&2; exit 2; }
command -v jq >/dev/null 2>&1 || { echo "jq not found" >&2; exit 2; }

# When this script runs inside a Claude Code session, the nested sessions
# would inherit the parent's session id and remote-session wiring. Drop
# those variables so each run is an independent session. A no-op in a
# plain terminal.
UNSET_PARENT=()
while IFS='=' read -r var _; do
  case "$var" in
    CLAUDECODE | CLAUDE_PID | CLAUDE_CODE_ENTRYPOINT | CLAUDE_CODE_SESSION_ID | \
      CLAUDE_CODE_REMOTE_SESSION_ID | CLAUDE_CODE_CHILD_SESSION | \
      CLAUDE_ADDITIONAL_DIRECTORIES | CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD | \
      CLAUDE_CODE_MESSAGING_* | CLAUDE_CODE_SYNC_* | CLAUDE_CODE_TEE_SDK_STDOUT | \
      SESSION_INGRESS_URL | CLAUDE_CODE_POST_FOR_SESSION_INGRESS_V2 | \
      CLAUDE_CODE_REMOTE_SEND_KEEPALIVES)
      UNSET_PARENT+=(-u "$var") ;;
  esac
done < <(env)

OUT_ROOT="/tmp/superpowers-tests/$(date +%s)-$$/deep-brainstorming"
mkdir -p "$OUT_ROOT"

# --- fixture ---------------------------------------------------------------
make_fixture() {
  local dir="$1"
  mkdir -p "$dir/src"
  cat >"$dir/cli.sh" <<'EOF'
#!/usr/bin/env bash
# Prints a sales report for the given month (YYYY-MM).
set -euo pipefail
month="${1:?usage: cli.sh YYYY-MM}"
node "$(dirname "$0")/src/report.js" "$month"
EOF
  chmod +x "$dir/cli.sh"
  cat >"$dir/src/report.js" <<'EOF'
// Builds the monthly sales report shown on the reports page and by cli.sh.
const sales = require('./sales.json');

function reportRows(month) {
  return sales.filter((s) => s.date.startsWith(month));
}

function renderReportsPage(month) {
  const rows = reportRows(month)
    .map((s) => `<tr><td>${s.date}</td><td>${s.item}</td><td>${s.amount}</td></tr>`)
    .join('');
  return `<h1>Sales ${month}</h1><table>${rows}</table>`;
}

if (require.main === module) {
  console.log(renderReportsPage(process.argv[2]));
}

module.exports = { reportRows, renderReportsPage };
EOF
  cat >"$dir/src/settings.js" <<'EOF'
// Settings page: currently only the display currency.
function renderSettingsPage(settings) {
  return `<h1>Settings</h1><label>Currency <input value="${settings.currency}"></label>`;
}

module.exports = { renderSettingsPage };
EOF
  cat >"$dir/src/sales.json" <<'EOF'
[
  { "date": "2026-08-03", "item": "Widget", "amount": 120 },
  { "date": "2026-08-17", "item": "Gadget", "amount": 75 },
  { "date": "2026-09-02", "item": "Widget", "amount": 130 }
]
EOF
  cat >"$dir/package.json" <<'EOF'
{ "name": "sales-reports", "version": "1.0.0", "private": true }
EOF
  (cd "$dir" && git init -q && git add -A &&
    git -c user.name=test -c user.email=test@example.com commit -qm "fixture")
}

# --- one run ---------------------------------------------------------------
# Prints: "<skills in order, space separated>|<written paths, space separated>"
run_once() {
  local prompt="$1" dir="$2" log="$3"
  make_fixture "$dir"
  (cd "$dir" && timeout "$RUN_TIMEOUT" env ${UNSET_PARENT[@]+"${UNSET_PARENT[@]}"} claude -p "$prompt" \
    --plugin-dir "$PLUGIN_DIR" \
    --allowed-tools "$ALLOWED_TOOLS" \
    --max-turns "$MAX_TURNS" \
    --output-format stream-json --verbose </dev/null >"$log" 2>&1) || true
  if ! grep -q '"type":"result"' "$log"; then
    printf 'ERROR|\n'
    return
  fi
  local skills writes
  skills="$(jq -r 'select(.type=="assistant") | .message.content[]?
      | select(.type=="tool_use" and .name=="Skill") | .input.skill // empty' \
      <(grep '^{' "$log") 2>/dev/null | sed 's/^superpowers://' | tr '\n' ' ')"
  writes="$(jq -r 'select(.type=="assistant") | .message.content[]?
      | select(.type=="tool_use" and (.name=="Write" or .name=="Edit" or .name=="MultiEdit" or .name=="NotebookEdit"))
      | .input.file_path // .input.notebook_path // empty' \
      <(grep '^{' "$log") 2>/dev/null | sed "s#^$dir/##" | tr '\n' ' ')"
  printf '%s|%s\n' "$skills" "$writes"
}

has_skill() { case " $1 " in *" $2 "*) return 0 ;; *) return 1 ;; esac; }

writes_only_specs() {
  local p
  for p in $1; do
    case "$p" in docs/superpowers/specs/*) ;; *) return 1 ;; esac
  done
  return 0
}

FAILURES=0

run_case() {
  local kind="$1" name="$2" prompt="$3"
  local hits=0 i result skills writes ok
  case "$ONLY" in all|"$kind"|"$name") ;; *) return ;; esac
  echo
  echo "[$kind] $name: \"$prompt\""
  for i in $(seq 1 "$REPS"); do
    local dir="$OUT_ROOT/$name/run$i/project" log="$OUT_ROOT/$name/run$i/stream.jsonl"
    mkdir -p "$(dirname "$log")"
    result="$(run_once "$prompt" "$dir" "$log")"
    skills="${result%%|*}"
    if [ "$skills" = ERROR ]; then
      echo "  run $i: ERROR (no result in log): $(head -c 200 "$log")"
      continue
    fi
    writes="${result#*|}"
    ok=0
    case "$kind" in
      positive)
        has_skill "$skills" deep-brainstorming && writes_only_specs "$writes" && ok=1 ;;
      borderline)
        has_skill "$skills" deep-brainstorming && writes_only_specs "$writes" && ok=1 ;;
      negative)
        has_skill "$skills" deep-brainstorming || ok=1 ;;
    esac
    [ "$ok" -eq 1 ] && hits=$((hits + 1))
    echo "  run $i: $([ "$ok" -eq 1 ] && echo hit || echo miss)  skills=[${skills% }] writes=[${writes% }]"
    echo "         log: $log"
  done
  local need
  case "$kind" in
    positive|negative) need="$REPS" ;;
    borderline) need=$(( (2 * REPS + 2) / 3 )) ;;
  esac
  if [ "$hits" -ge "$need" ]; then
    echo "  [PASS] $name: $hits/$REPS (need $need)"
  else
    echo "  [FAIL] $name: $hits/$REPS (need $need)"
    FAILURES=$((FAILURES + 1))
  fi
}

echo "deep-brainstorming trigger test"
echo "plugin: $PLUGIN_DIR"
echo "claude: $(claude --version 2>/dev/null)"
echo "logs:   $OUT_ROOT"

run_case positive react-todo "Let's make a react todo list"
run_case borderline dark-mode "add dark mode to the settings page"
run_case borderline csv-export "add CSV export to the reports page"
run_case borderline specified-feature "I want CSV export for the reports page. Outcome: an accountant can download a month's rows as a CSV file to open in Excel. Scope: a Download CSV link on the reports page plus a renderReportCsv(month) function; no CLI changes. Constraints: no new dependencies, reuse reportRows, header row date,item,amount, RFC 4180 quoting. Acceptance: CSV rows match the table rows for the month, an empty month gives just the header row, and item names with commas or quotes are quoted correctly."
run_case negative verbose-flag "Add a --verbose flag to cli.sh"

echo
echo "Failed cases: $FAILURES"
[ "$FAILURES" -eq 0 ]
