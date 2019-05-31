#/bin/sh!
set -o xtrace
set -e
sh scripts/prepareWin64Package.sh
sh scripts/prepareOSXPackage.sh
sh scripts/prepareLinux64Package.sh
find . -name "GT4Famix3-*/*" -print