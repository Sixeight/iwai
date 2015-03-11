#! /bin/sh

git reset HEAD --hard
git checkout deploy
git merge master
if [ ! -f config/database.yml ]; then
  echo "create database.yml"
  cp config/{_,}database.yml
fi
npm install
gulp browserify
git commit -am "deploy commit"
git push heroku deploy:master
