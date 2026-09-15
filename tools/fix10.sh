#!/usr/bin/env bash
cd "$(dirname "$0")/.."
git add -A
git commit -m "Drop the notes link from the contact actions. Two options, not three."
git push
echo
git log --oneline -2
git status --short --branch | head -1
