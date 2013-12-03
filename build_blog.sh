#!/bin/sh
cd ~/raw.gongshw.github.io; 
git add .;
git commit -am 'Latest build.';
git push;
jekyll build;
cp -r _site/ ../gongshw.github.io/;
cd ../gongshw.github.io/;
git add .;
git commit -am 'Latest build.';
git push;

