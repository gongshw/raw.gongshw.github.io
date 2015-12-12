#!/bin/sh
if [ $# -eq 0 ]; then
    echo "git need a commit message!"
    exit 1
fi
cd ~/raw.gongshw.github.io; 
jekyll build || error_exit "$LINENO: jekyll build failed";
git add .;
git commit -am "${1}";
git push;
cd ../gongshw.github.io/;
git pull
rm -rf ./*;
cp -r ../raw.gongshw.github.io/_site/* .;
git add .;
git commit -am "[auto sync] ${1}";
git push;

