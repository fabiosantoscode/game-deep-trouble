#!/bin/bash

set -e  # Exit on error

DEPLOY_DIR=".deploy"
DIST_DIR="web"

# 1. Clean deploy folder
rm -rf "$DEPLOY_DIR"

# 2. Clone gh-pages into deploy folder
git clone --branch gh-pages --depth 1 \
  https://github.com/fabiosantoscode/game-deep-trouble.git "$DEPLOY_DIR"

# 3. Delete all files (except .git) and rebuild from ../dist
cd "$DEPLOY_DIR"
git rm -rfq . || true  # Quietly remove everything
cp -r "../$DIST_DIR"/* .  # Copy new files

# 4. Commit and push
git add --all
git commit -m "Deploy $(date +'%Y-%m-%d %H:%M:%S')"
git push origin gh-pages

cd ..
rm -rf "$DEPLOY_DIR"  # Cleanup
echo "✅ Deployed to gh-pages!"
