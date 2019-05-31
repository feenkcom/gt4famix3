#!/bin/sh
set -e
PROJECT_VERSION=$( cat projectversion.txt )
GT4Famix3Folder=GT4Famix3Win64-$PROJECT_VERSION
mkdir -p $GT4Famix3Folder
cp -rv GT4Famix3-*/* $GT4Famix3Folder
rm -rf $GT4Famix3Folder/pharo-local

curl http://files.pharo.org/get-files/70/pharo64-win-stable.zip -o pharo64-win-stable.zip
unzip pharo64-win-stable.zip -d pharo64-win-stable
mv -fv pharo64-win-stable/* $GT4Famix3Folder/

curl https://dl.feenk.com/Glutin/windows/development/x86_64/libGlutin.dll -o libGlutin.dll
curl https://dl.feenk.com/Moz2D/windows/development/x86_64/msvcp140.dll -o msvcp140.dll
curl https://dl.feenk.com/Moz2D/windows/development/x86_64/vcruntime140.dll -o vcruntime140.dll
curl https://dl.feenk.com/Moz2D/windows/development/x86_64/libMoz2D.dll -o libMoz2D.dll
mv libGlutin.dll $GT4Famix3Folder
mv msvcp140.dll $GT4Famix3Folder
mv vcruntime140.dll $GT4Famix3Folder
mv libMoz2D.dll $GT4Famix3Folder

zip -qyr $GT4Famix3Folder.zip $GT4Famix3Folder
rm -rf $GT4Famix3Folder
set +e

