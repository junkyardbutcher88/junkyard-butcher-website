#!/usr/bin/env bash
cd "$(dirname "$0")/.."
git add -A
git commit -m "Record the stale device-write gotcha in DECISIONS."
git push
echo
git log --oneline -2
git status --short --branch | head -1
