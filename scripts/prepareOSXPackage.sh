#!/bin/sh
set -e
PROJECT_VERSION=$( cat projectversion.txt )
GT4Famix3Folder=GT4Famix3OSX64-$PROJECT_VERSION
mkdir -p $GT4Famix3Folder
cp -rv GT4Famix3-*/* $GT4Famix3Folder
rm -rf $GT4Famix3Folder/pharo-local


curl https://files.pharo.org/get-files/70/pharo64-mac-stable.zip -o pharo64-mac-stable.zip
unzip pharo64-mac-stable.zip -d pharo64-mac-stable
mv -fv pharo64-mac-stable/* $GT4Famix3Folder/

curl https://dl.feenk.com/Glutin/osx/development/x86_64/libGlutin.dylib -o libGlutin.dylib
mv libGlutin.dylib $GT4Famix3Folder

curl https://dl.feenk.com/Moz2D/osx/development/x86_64/libMoz2D.dylib -o libMoz2D.dylib
mv libMoz2D.dylib $GT4Famix3Folder

zip -qyr $GT4Famix3Folder.zip $GT4Famix3Folder
rm -rf $GT4Famix3Folder
set +e