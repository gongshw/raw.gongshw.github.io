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
rm -rf ../gongshw.github.io/*;
cp -r _site/* ../gongshw.github.io/;
cd ../gongshw.github.io/;
git add .;
git commit -am "${1}";
git push;

