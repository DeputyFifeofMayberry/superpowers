#!/usr/bin/env bash
# Structural checks for skills/deep-brainstorming. Behavior is tested by
# test-trigger.sh (headless, opt-in) and manual-acceptance.md; this script
# only checks the things a shell can check: frontmatter, referenced files
# exist, word budget, argument-substitution hazards, wiring into
# brainstorming and the Muse manifest.
set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL_DIR="$REPO_ROOT/skills/deep-brainstorming"
SKILL_MD="$SKILL_DIR/SKILL.md"
BRAINSTORMING_MD="$REPO_ROOT/skills/brainstorming/SKILL.md"
MUSE_MANIFEST="$REPO_ROOT/.muse-plugin/plugin.json"
WORD_BUDGET=1500

PASSES=0
FAILURES=0

pass() { echo "  [PASS] $1"; PASSES=$((PASSES + 1)); }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "deep-brainstorming structure"

# --- SKILL.md frontmatter -------------------------------------------------
if [ -f "$SKILL_MD" ]; then
  pass "SKILL.md exists"
  frontmatter="$(awk 'NR==1 && $0!="---"{exit} NR>1 && $0=="---"{exit} NR>1{print}' "$SKILL_MD")"
  if printf '%s\n' "$frontmatter" | grep -q '^name: deep-brainstorming$'; then
    pass "frontmatter name is deep-brainstorming"
  else
    fail "frontmatter name is deep-brainstorming"
  fi
  description="$(printf '%s\n' "$frontmatter" | awk '/^description:/{sub(/^description:[ ]*/,""); print; found=1; next} found && /^[ ]/{print} found && !/^[ ]/{exit}' | tr '\n' ' ')"
  description="${description#\"}"
  # Trigger-critical skills in this repo (brainstorming) open with
  # "You MUST use this"; others open with "Use when".
  if printf '%s' "$description" | grep -qE '^(Use when|You MUST use this)'; then
    pass "description starts with 'Use when' or 'You MUST use this'"
  else
    fail "description starts with 'Use when' or 'You MUST use this' (got: ${description:0:60})"
  fi
  if [ "${#description}" -le 1024 ]; then
    pass "description under 1024 characters"
  else
    fail "description under 1024 characters (${#description})"
  fi
  for banned in "dispatch" "then" "step"; do
    if printf '%s' "$description" | grep -qiw "$banned"; then
      fail "description contains workflow word '$banned'"
    else
      pass "description avoids workflow word '$banned'"
    fi
  done
  if printf '%s\n' "$frontmatter" | grep -q '^disable-model-invocation:'; then
    fail "skill stays model-invocable (no disable-model-invocation)"
  else
    pass "skill stays model-invocable (no disable-model-invocation)"
  fi

  body="$(awk 'BEGIN{fm=0} NR==1 && $0=="---"{fm=1; next} fm==1 && $0=="---"{fm=2; next} fm==2{print}' "$SKILL_MD")"

  # --- word budget --------------------------------------------------------
  body_words="$(printf '%s\n' "$body" | wc -w | tr -d ' ')"
  if [ "$body_words" -le "$WORD_BUDGET" ]; then
    pass "SKILL.md body within $WORD_BUDGET words ($body_words)"
  else
    fail "SKILL.md body within $WORD_BUDGET words ($body_words)"
  fi

  # --- required sections --------------------------------------------------
  for heading in "## Hard rules" "## Red Flags"; do
    if grep -q "^$heading" "$SKILL_MD"; then
      pass "SKILL.md has section '$heading'"
    else
      fail "SKILL.md has section '$heading'"
    fi
  done

  # Hard rules must come first so they survive compaction truncation.
  first_heading="$(printf '%s\n' "$body" | grep -m1 '^## ')"
  if [ "$first_heading" = "## Hard rules" ]; then
    pass "'## Hard rules' is the first section"
  else
    fail "'## Hard rules' is the first section (got: $first_heading)"
  fi

  # --- argument substitution hazards --------------------------------------
  # Claude Code replaces $ARGUMENTS and $0..$9 in skill bodies.
  # shellcheck disable=SC2016 # literal placeholders, not expansions
  arg_hits="$(printf '%s\n' "$body" | grep -n -E '\$ARGUMENTS|\$[0-9]' || true)"
  if [ -z "$arg_hits" ]; then
    pass "SKILL.md has no argument placeholders"
  else
    fail "SKILL.md has no argument placeholders"
    printf '%s\n' "$arg_hits" | head -5 | sed 's/^/    /'
  fi

  # --- never instructs a commit -------------------------------------------
  commit_hits="$(grep -rn 'git commit' "$SKILL_DIR" --include='*.md' 2>/dev/null || true)"
  if [ -z "$commit_hits" ]; then
    pass "skill files never instruct 'git commit'"
  else
    fail "skill files never instruct 'git commit'"
    printf '%s\n' "$commit_hits" | head -5 | sed 's/^/    /'
  fi

  # --- every referenced skill file exists --------------------------------
  refs="$(grep -o '\(templates\|prompts\)/[A-Za-z0-9._-]*\.md' "$SKILL_MD" | sort -u)"
  if [ -n "$refs" ]; then
    while IFS= read -r ref; do
      if [ -f "$SKILL_DIR/$ref" ]; then
        pass "referenced file exists: $ref"
      else
        fail "referenced file exists: $ref"
      fi
    done <<<"$refs"
  else
    fail "SKILL.md references its templates/prompts files"
  fi
  if grep -q 'skills/brainstorming/visual-companion.md' "$SKILL_MD"; then
    if [ -f "$REPO_ROOT/skills/brainstorming/visual-companion.md" ]; then
      pass "referenced file exists: skills/brainstorming/visual-companion.md"
    else
      fail "referenced file exists: skills/brainstorming/visual-companion.md"
    fi
  fi
else
  fail "SKILL.md exists"
fi

# --- expected files -------------------------------------------------------
for rel in templates/record.md prompts/research-helper.md; do
  if [ -f "$SKILL_DIR/$rel" ]; then
    pass "expected file present: $rel"
  else
    fail "expected file present: $rel"
  fi
done

# --- record template carries the resume keys ------------------------------
RECORD="$SKILL_DIR/templates/record.md"
if [ -f "$RECORD" ]; then
  for key in "Deep Brainstorming Record" "Topic:" "Status:" "abandoned" "## Decisions" "## Evidence" "## Assumptions" "## Open questions" "## Design"; do
    if grep -q "$key" "$RECORD"; then
      pass "record template contains '$key'"
    else
      fail "record template contains '$key'"
    fi
  done
fi

# --- wiring: brainstorming hands off, Muse lists the skill ----------------
if grep -q 'superpowers:deep-brainstorming' "$BRAINSTORMING_MD"; then
  pass "brainstorming hands off to superpowers:deep-brainstorming"
else
  fail "brainstorming hands off to superpowers:deep-brainstorming"
fi
if grep -q '"id": "deep-brainstorming"' "$MUSE_MANIFEST" &&
  grep -q '"path": "skills/deep-brainstorming/SKILL.md"' "$MUSE_MANIFEST"; then
  pass "Muse manifest lists deep-brainstorming"
else
  fail "Muse manifest lists deep-brainstorming"
fi

# --- no local paths or names in shipped files ----------------------------
leaks="$(grep -rn -E '/Users/|/home/|/tmp/claude' "$SKILL_DIR" 2>/dev/null || true)"
if [ -z "$leaks" ]; then
  pass "no machine-specific paths in skill files"
else
  fail "no machine-specific paths in skill files"
  printf '%s\n' "$leaks" | head -10 | sed 's/^/    /'
fi

# --- "the user" never appears in skill prose -----------------------------
user_hits="$(grep -rn -i 'the user' "$SKILL_DIR" --include='*.md' 2>/dev/null || true)"
if [ -z "$user_hits" ]; then
  pass "skill files say 'your human partner', not 'the user'"
else
  fail "skill files say 'your human partner', not 'the user'"
  printf '%s\n' "$user_hits" | head -10 | sed 's/^/    /'
fi

echo
echo "Passed: $PASSES  Failed: $FAILURES"
[ "$FAILURES" -eq 0 ]
