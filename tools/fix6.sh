#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== STATUS ========"
git status --short
echo
git add -A
git commit -m "Hero D: name at scale, three facts under it. The Dig at \$1,500. Nav in nouns. Kannabis gets its outcome, Premium Blossom gets its quote, Est. Now goes."
echo
git push
echo
git log --oneline -2
git status --short --branch | head -1
