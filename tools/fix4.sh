#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== STATUS ========"
git status --short
echo
echo "======== COMMIT ========"
git add -A
git commit -m "The door: a real hire form under the work, every conversation CTA routed to it. Archive tags cut, cannabis line plays offense. Shared jb.css, philosophy gets the grain."
echo
echo "======== PUSH ========"
git push
echo
git log --oneline -2
git status --short --branch | head -1
