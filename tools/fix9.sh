#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== STATUS ========"
git status --short
echo
git add -A
git commit -m "Drop the fallback panel now Formspree is live. Cut to Order replaces Bring Me a Job; nav reads Contact. Footer signup says what it does."
echo
git push
echo
git log --oneline -2
git status --short --branch | head -1
