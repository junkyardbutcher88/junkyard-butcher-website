#!/usr/bin/env bash
cd "$(dirname "$0")/.."
git add -A
git commit -m "DECISIONS: correct the mono rule — stills hover to colour, reels wait for play"
git push
echo
git log --oneline -1
git status --short --branch | head -1
