#!/usr/bin/env bash
cd "$(dirname "$0")/.."
echo "======== UNTRACK THE PREVIEW PNGS (files stay on disk) ========"
git rm -r --cached "Claude outputs" >/dev/null 2>&1 && echo "untracked: Claude outputs/" || echo "nothing to untrack"
grep -q 'Claude outputs' .gitignore || printf '\n# preview renders Claude drops here - not part of the site\nClaude outputs/\n' >> .gitignore
echo
echo "======== COMMIT ========"
git add -A
git commit -m "Untrack the preview renders that got swept into the last commit."
git push
echo
git log --oneline -2
git status --short --branch | head -1
