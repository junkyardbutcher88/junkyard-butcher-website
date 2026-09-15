#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== COMMITS THIS SESSION ========"
git log --oneline 9c265a8..HEAD
echo
echo "======== FILES CHANGED PER COMMIT ========"
for c in $(git rev-list --reverse 9c265a8..HEAD); do
  echo "--- $(git log -1 --format='%h %s' $c)"
  git show --stat --oneline $c | tail -n +2
  echo
done
echo "======== NET CHANGE 9c265a8 -> HEAD ========"
git diff --stat 9c265a8 HEAD
echo
echo "======== SYNC ========"
git status --short --branch | head -1
