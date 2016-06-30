#!/bin/sh
if [ $# -eq 0 ]; then
    echo "git need a commit message!"
    exit 1
fi
RAW_PATH="~/raw.gongshw.github.io"
SITE_PATH="~/gongshw.github.io"
cd $RAW_PATH; 
jekyll _2.5.3_ build || error_exit "$LINENO: jekyll build failed";
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

