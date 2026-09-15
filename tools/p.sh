#!/usr/bin/env bash
cd "$(dirname "$0")/.."
git add -A
git commit -m "DECISIONS: record mono-until-engaged as a site-wide rule"
git push
echo
git log --oneline -2
git status --short --branch | head -1
