#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== STATUS ========"
git status --short
echo
git add -A
git commit -m "Signup slab out, one quiet line in the footer. Each case study names the principle that did the work. Philosophy: borrowed names replaced with where it actually comes from. Tap targets, dead anchor, orphaned CSS."
echo
git push
echo
git log --oneline -2
git status --short --branch | head -1
