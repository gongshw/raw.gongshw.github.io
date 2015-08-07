#!/bin/sh
cd ~/raw.gongshw.github.io; 
jekyll build || error_exit "$LINENO: jekyll build failed";
git add .;
git commit -am "Latest build: ${1}";
git push;
rm -rf ../gongshw.github.io/*;
cp -r _site/* ../gongshw.github.io/;
cd ../gongshw.github.io/;
git add .;
git commit -am "Latest build: ${1}";
git push;

