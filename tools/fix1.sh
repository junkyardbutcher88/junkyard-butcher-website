#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== HEAD STAT ========"
git show --stat --oneline HEAD | head -20
echo
echo "======== AMEND + PUSH ========"
git commit --amend -m "Wire real Drive imagery into the work section: byline camera shot, CVALT email strip, Bosky 4-up, Premium Blossom 3-up."
git push --force-with-lease
echo
git log --oneline -3
git status --short --branch | head -1
