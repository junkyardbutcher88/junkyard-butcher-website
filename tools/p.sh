#!/usr/bin/env bash
cd "$(dirname "$0")/.."
git add -A
git commit -m "DECISIONS: one brand page for CVALT, stat-line-first, previews keep motion"
git push
echo
git log --oneline -2
git status --short --branch | head -1
