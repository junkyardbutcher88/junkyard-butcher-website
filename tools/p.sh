#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "index.html bytes: $(wc -c < index.html)   <- want 84317"
git add -A
git commit -m "Mono until engaged: all stills and reels desaturated at rest, colour in the lightbox; stills now enlarge on click"
git push
echo
git log --oneline -2
git status --short --branch | head -1
