#!/usr/bin/env bash
# Exercise the existing task extractor against the optional compact format.
set -euo pipefail
dir=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$dir/../.." && pwd)
plan="$dir/fixtures/compact-plan.md"
extractor="$root/skills/subagent-driven-development/scripts/task-brief"
brief=$(mktemp)
trap 'rm -f -- "$brief"' EXIT

bash "$extractor" "$plan" 1 "$brief"
grep -q '^### Task 1:' "$brief"
grep -q '^\*\*Interfaces:\*\*' "$brief"
grep -q 'Red: run' "$brief"
grep -q 'Green: run' "$brief"
grep -q 'Commit the verified capability' "$brief"
if grep -q '^### Task 2:' "$brief"; then
  echo 'FAIL: task 1 includes task 2' >&2
  exit 1
fi
echo 'PASS: task 1 retains compact evidence and stops before task 2'

bash "$extractor" "$plan" 2 "$brief"
grep -q '^### Task 2:' "$brief"
grep -q "Task 1's" "$brief"
grep -q 'test_nonmember_cannot_share' "$brief"
echo 'PASS: task 2 retains dependency and negative acceptance case'

rc=0
bash "$extractor" "$plan" 99 "$brief" >/dev/null 2>&1 || rc=$?
test "$rc" -eq 3
echo 'PASS: code-fenced Task 99 is not extracted as a task'
