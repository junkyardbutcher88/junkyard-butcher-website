#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== STATUS ========"
git status --short
echo
echo "======== COMMIT ========"
git add -A
git commit -m "Galleries: one or two previews, the whole set in the album. Tiles match source orientation."
echo
echo "======== PUSH ========"
git push
echo
git log --oneline -2
git status --short --branch | head -1
