#!/bin/bash

set -euo pipefail

DEPLOY_DIR=".deploy"
DIST_DIR="web"
REPOSITORY="https://github.com/fabiosantoscode/game-deep-trouble.git"

# 1. Clean deploy folder
rm -rf "$DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"
cd "$DEPLOY_DIR"

# 2. Clone gh-pages into deploy folder
git init
git checkout --orphan gh-pages
git remote add origin "$REPOSITORY"

# 3. publish the contents of ../dist
cp -r "../$DIST_DIR"/* .  # Copy new files

# 4. Commit and push
git add --all
git commit -m "Deploy $(date +'%Y-%m-%d %H:%M:%S')"
git push --force origin gh-pages

cd ..
rm -rf "$DEPLOY_DIR"  # Cleanup
echo "✅ Deployed to gh-pages!"
