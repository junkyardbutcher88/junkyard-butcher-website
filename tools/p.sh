#!/usr/bin/env bash
cd "$(dirname "$0")/.."
git add -A
git commit -m "Lightbox becomes an album: arrow keys, swipe, per-card grouping. Menu reordered into operational sequence. Drop dead CSS."
git push
echo
git log --oneline -1
git status --short --branch | head -1
