#!/bin/sh
cd ~/raw.gongshw.github.io; 
jekyll build || error_exit "$LINENO: jekyll build failed";
git add .;
git commit -am "Latest build: ${1}";
git push;
yes|cp -r _site/ ../gongshw.github.io/;
cd ../gongshw.github.io/;
git add .;
git commit -am "Latest build: ${1}";
git push;

