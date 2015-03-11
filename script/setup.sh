#! /bin/sh

DB_NAME=iwai_development

dropdb $DB_NAME
createdb $DB_NAME
psql $DB_NAME < db/scheme.sql

npm install
if [ ! -f public/js/app.js ]; then
  gulp browserify
fi

if [ ! -f config/database.yml ]; then
  cp config/{_,}database.yml
fi

PERL_AUTOINSTALL=--defaultdeps LANG=C cpanm --installdeps --notest .
