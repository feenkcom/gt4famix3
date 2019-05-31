#!/bin/sh
set -e

PROJECT_VERSION=$( cat projectversion.txt )
GT4Famix3Folder=GT4Famix3Linux64-$PROJECT_VERSION
mkdir -p $GT4Famix3Folder
cp -rv GT4Famix3-*/* $GT4Famix3Folder
rm -rf $GT4Famix3Folder/pharo-local

curl https://files.pharo.org/get-files/70/pharo64-linux-stable.zip -o pharo64-linux-stable.zip
unzip pharo64-linux-stable.zip -d pharo64-linux-stable
mv -fv pharo64-linux-stable/* $GT4Famix3Folder/

curl https://dl.feenk.com/Glutin/linux/development/x86_64/libGlutin.so -o libGlutin.so
mv libGlutin.so $GT4Famix3Folder

curl https://dl.feenk.com/Moz2D/linux/development/x86_64/libMoz2D.so -o libMoz2D.so
mv libMoz2D.so $GT4Famix3Folder

zip -qyr $GT4Famix3Folder.zip $GT4Famix3Folder
rm -rf $GT4Famix3Folder
set +e