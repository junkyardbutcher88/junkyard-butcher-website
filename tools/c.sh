#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== SANITY ========"
echo "index.html bytes: $(wc -c < index.html)   <- want 81726"
grep -c 'class="jb"' index.html | xargs echo "jb player present:"
ls 404.html DECISIONS.md >/dev/null 2>&1 && echo "404 + DECISIONS: present" || echo "404/DECISIONS: MISSING"
echo
echo "======== STATUS ========"
git status --short
echo
echo "======== COMMIT ========"
git add -A
git commit -m "Merge working copy, add jb-video player, film grain, 404 page, DECISIONS"
echo
echo "======== PUSH ========"
git push
echo
echo "======== RESULT ========"
git log --oneline -3
git status --short --branch | head -1
