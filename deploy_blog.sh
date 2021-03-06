#!/bin/sh
if [ $# -eq 0 ]; then
    echo "git need a commit message!"
    exit 1
fi

RAW_PATH="$HOME/raw.gongshw.github.io"
SITE_PATH="$HOME/gongshw.github.io"
JEKYLL_VERSION="2.5.3"

cd $RAW_PATH; 
jekyll _${JEKYLL_VERSION}_ build || error_exit "$LINENO: jekyll build failed";
git add .;
git commit -am "${1}";
git push;
cd $SITE_PATH;
git pull
rm -rf $SITE_PATH/*;
cp -r $RAW_PATH/_site/* .;
git add .;
git commit -am "[auto sync] ${1}";
git push;

