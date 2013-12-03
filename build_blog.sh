#!/bin/sh
cd ~/raw.gongshw.github.io; 
jekyll build || error_exit "$LINENO: jekyll build failed";
git add .;
git commit -am 'Latest build.';
git push;
cp -r _site/ ../gongshw.github.io/;
cd ../gongshw.github.io/;
git add .;
git commit -am 'Latest build.';
git push;

