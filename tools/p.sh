#!/usr/bin/env bash
cd "$(dirname "$0")/.."
git add -A
git commit -m "Fix: frame grain and gradient overlays were eating pointer events, blocking hover and clicks on stills"
git push
echo
git log --oneline -1
git status --short --branch | head -1
