#!/usr/bin/env bash
# Demonstrates: stash, cherry-pick, rebase, revert, reset, file recovery, graph log.
# Run inside the project after `git init` and after at least one commit exists.
set -euo pipefail

cd "$(dirname "$0")/.."

echo "===== git workflow demo ====="

# stash
echo "demo-stash" >> README.md
git stash push -m "demo-stash"
git stash list
git stash pop || true

# cherry-pick (cherry-pick last commit from staging onto current branch)
LAST_STAGING=$(git rev-parse staging 2>/dev/null || true)
if [ -n "$LAST_STAGING" ]; then
  echo "Would cherry-pick $LAST_STAGING (skipped in demo to avoid conflicts)"
fi

# rebase (interactive rebase last 2 commits noninteractive: just show command)
echo "Rebase example:  git rebase -i HEAD~2"

# revert + reset demo on a throwaway commit
echo "tmp" > tmp-demo.txt
git add tmp-demo.txt
git commit -m "demo: temp file for revert"
git revert --no-edit HEAD
echo "Reverted. Now demonstrating reset on a second temp commit."
echo "tmp2" > tmp-demo2.txt
git add tmp-demo2.txt
git commit -m "demo: temp file for reset"
git reset --soft HEAD~1
git restore --staged tmp-demo2.txt
rm -f tmp-demo2.txt

# Recover a deleted file using git
echo "recoverable" > recover-me.txt
git add recover-me.txt
git commit -m "demo: file to delete and recover"
rm recover-me.txt
git checkout -- recover-me.txt
echo "Recovered: $(cat recover-me.txt)"
git rm recover-me.txt
git commit -m "demo: cleanup recovered file"

# Graphical commit history
git log --oneline --graph --decorate --all | head -40

echo "===== done ====="
