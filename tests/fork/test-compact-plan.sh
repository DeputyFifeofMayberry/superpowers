#!/usr/bin/env bash
# Check the live format wiring and extract tasks rendered from its template.
set -euo pipefail
dir=$(cd "$(dirname "$0")" && pwd)
root=${SUPERPOWERS_TEST_ROOT:-$(cd "$dir/../.." && pwd)}
skill="$root/skills/writing-plans/SKILL.md"
reference="$root/skills/writing-plans/vertical-slice-plans.md"
extractor="$root/skills/subagent-driven-development/scripts/task-brief"
brief=$(mktemp)
template=$(mktemp)
plan=$(mktemp)
trap 'rm -f -- "$brief" "$template" "$plan"' EXIT

require() {
  if ! grep -qE "$1" "$2"; then
    echo "FAIL: $3" >&2
    exit 1
  fi
}
require '\.superpowers/fork-features\.json' "$skill" 'profile selector is wired into writing-plans'
require '\]\(vertical-slice-plans\.md\)' "$skill" 'compact reference is linked from writing-plans'
awk '/^````markdown$/ { capture=1; next } /^````$/ && capture { exit } capture { print }' "$reference" > "$template"
require '^### Task N:' "$template" 'live template uses extractable Task N headings'
require '^\*\*Files:\*\*' "$template" 'live template specifies files'
require '^\*\*Interfaces:\*\*' "$template" 'live template specifies interfaces'
for label in Red Green Regression; do
  require "^[[:space:]]*$label:" "$template" "live template includes $label evidence"
done
test "$(grep -cE '^[[:space:]]*Expected:' "$template")" -eq 3 || {
  echo 'FAIL: Red, Green and Regression each require an Expected: line' >&2
  exit 1
}
require '^```' "$template" 'acceptance assertions have a code block'
echo 'PASS: live selector and template contracts are present'

# Fill the live template with illustrative fixture values, not a parallel plan.
for n in 1 2; do
  sed -e "s/Task N:/Task $n:/" \
      -e "s/\[User-visible capability\]/Capability $n/" \
      -e 's|exact/existing/path|app/search.py|g' \
      -e 's|exact/new/path|app/saved_search.py|g' \
      -e 's|tests/exact/path|tests/test_saved_search.py|g' \
      -e 's|exact/test/path|tests/test_saved_search.py|g' \
      -e 's|\[exact existing or earlier-task signatures/types\]|current_member() -> Member|' \
      -e 's|\[exact signatures/types needed by later tasks\]|save_search(owner_id: str, query: str) -> SavedSearch|' \
      -e 's|\[capability\]|saving a search|' \
      -e 's|\[test names and exact assertions; spec values and error cases\]|test_saved_search_survives_reload|' \
      -e 's|\[actual test code with assertions using exact spec values\]|assert restored.query == "release status"|' \
      -e 's|\[actual project command\]|pytest tests/test_saved_search.py -q|g' \
      -e 's|\[the missing behavior, not an unrelated setup error\]|FAIL because saved searches do not persist|' \
      -e 's|\[paths, signatures, and decisions the engineer cannot infer\]|save_search(owner_id: str, query: str) -> SavedSearch in app/saved_search.py|' \
      -e 's|\[explicit passing result\]|all tests pass; exit 0|g' \
      -e 's|\[relevant existing checks\]|pytest tests/test_search.py -q|' \
      -e 's|\[exact changed paths\]|app/search.py, app/saved_search.py, tests/test_saved_search.py|' \
      -e 's|\[intended commit message\]|feat: save searches|' "$template" >> "$plan"
  if [[ "$n" -eq 1 ]]; then
    printf '\n```markdown\n### Task 99: This fenced heading is not a real task\n```\n\n' >> "$plan"
  fi
done
if grep -qE '\[[^] ]' "$plan"; then
  echo 'FAIL: rendered template contains an unresolved slot' >&2
  exit 1
fi

bash "$extractor" "$plan" 1 "$brief"
grep -q '^### Task 1:' "$brief"
grep -q '^\*\*Interfaces:\*\*' "$brief"
grep -q 'Red: run' "$brief"
grep -q 'Green: run' "$brief"
test "$(grep -cE '^[[:space:]]*Expected:' "$brief")" -eq 3
grep -q 'assert restored.query == "release status"' "$brief"
grep -q 'Commit the verified capability' "$brief"
if grep -q '^### Task 2:' "$brief"; then
  echo 'FAIL: task 1 includes task 2' >&2
  exit 1
fi
echo 'PASS: task 1 retains compact evidence and stops before task 2'

bash "$extractor" "$plan" 2 "$brief"
grep -q '^### Task 2:' "$brief"
grep -q 'save_search(owner_id: str, query: str) -> SavedSearch' "$brief"
test "$(grep -cE '^[[:space:]]*Expected:' "$brief")" -eq 3
echo 'PASS: task 2 retains interface and command expectations'

rc=0
bash "$extractor" "$plan" 99 "$brief" >/dev/null 2>&1 || rc=$?
test "$rc" -eq 3
echo 'PASS: code-fenced Task 99 is not extracted as a task'
