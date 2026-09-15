#!/usr/bin/env bash
# Dump HEAD's index.html so Claude can merge against the working copy.
cd "$(dirname "$0")/.."
git show HEAD:index.html > tools/HEAD_index.html
echo "wrote tools/HEAD_index.html ($(wc -c < tools/HEAD_index.html) bytes)"
echo "working copy: $(wc -c < index.html) bytes"
echo
echo "=== what the working copy ADDED vs HEAD (its unique lines) ==="
git diff --unified=0 HEAD -- index.html | grep '^+' | grep -v '^+++' | head -40
