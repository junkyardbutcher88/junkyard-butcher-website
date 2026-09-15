#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== GIT STATUS ========"
git status --short
echo
echo "======== DIFF vs HEAD ========"
git diff --stat
echo
echo "======== is cvalt_alterlean in HEAD? ========"
git show HEAD:index.html | grep -c "cvalt_alterlean" || echo 0
echo "======== is it in the working file? ========"
grep -c "cvalt_alterlean" index.html || echo 0
echo
echo "======== assets on disk ========"
ls assets/
echo
echo "======== last 3 commits ========"
git log --oneline -3
