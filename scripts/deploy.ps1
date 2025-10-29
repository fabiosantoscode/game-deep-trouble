
$DEPLOY_DIR=".deploy"
$REPOSITORY="git@github.com:fabiosantoscode/game-deep-trouble.git"

rm -Recurse -Force -ErrorAction Ignore "$DEPLOY_DIR"
mkdir "$DEPLOY_DIR"
cd "$DEPLOY_DIR"

git init
git checkout --orphan gh-pages
git remote add origin $REPOSITORY

cp -r ..\web\* .

git add --all
git commit -m "Deploy"
git push --force origin gh-pages

cd ..
rm -Recurse -Force -ErrorAction Ignore "$DEPLOY_DIR"
echo "✅ Deployed to gh-pages!"
