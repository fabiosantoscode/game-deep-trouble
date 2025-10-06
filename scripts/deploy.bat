
set DEPLOY_DIR=".deploy"
set REPOSITORY="git@github.com:fabiosantoscode/game-deep-trouble.git"

del /q .deploy || goto :error
mkdir .deploy || echo "meh"
cd .deploy || goto :error

del /q .git || echo "meh"
del /q .git\refs\heads || echo "meh"
git init || goto :error
git checkout --orphan gh-pages || goto :error
git remote add origin %REPOSITORY% || goto :error

xcopy ..\web .\ /s /e || goto :error

git add --all || goto :error
git commit -m "Deploy" || goto :error
git push --force origin gh-pages || goto :error

del /q .deploy || goto :error
echo "✅ Deployed to gh-pages!"

goto :EOF

:error

echo Failed with error #%errorlevel%.
exit /b %errorlevel%