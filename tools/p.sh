#!/usr/bin/env bash
cd "$(dirname "$0")/.."
git add -A
git commit -m "Stills colour on hover; reels stay mono until played"
git push
echo
git log --oneline -2
git status --short --branch | head -1
