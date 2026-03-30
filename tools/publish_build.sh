#!/usr/bin/env bash
# TODO:
# 0. Abort if local changes are not committed.
# 1. Clear build directory.
# 2. Build Twee project.
# 3. Build Graph.

COMMIT=false
PUSH=false
while [[ $# -gt 0 ]]; do
  case $1 in
    --commit) COMMIT=true; shift ;;
    --push) PUSH=true; shift ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: $0 [--commit] [--push]" >&2
      exit 1
      ;;
  esac
done

# Stash build directory
git stash -a -- build

# switch to build branch
git switch build

# pull latest changes (for safety)
git pull origin build

# Transfer stashed build files from main branch
git checkout 'stash@{0}^3' -- build

# Stage build files
git add build

if [[ "$COMMIT" == true ]]; then
  git commit -m "New build"
fi

if [[ "$PUSH" == true ]]; then
  git push
fi

# Drop stash
git stash drop 'stash@{0}'
