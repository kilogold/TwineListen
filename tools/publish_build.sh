# TODO:
# 0. Abort if local changes are not committed.
# 1. Clear build directory.
# 2. Build Twee project.
# 3. Build Graph.

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

# Commit as new build
git commit -m "New build"

# Push build to remote
git push

# Drop stash
git stash drop 'stash@{0}'
