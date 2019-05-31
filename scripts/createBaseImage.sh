#/bin/sh!
set -o xtrace
set -e

export PROJECT_VERSION="$(date +'%Y%m%d%H%M%S')-$(git log --format=%h -1)"
echo $PROJECT_VERSION > projectversion.txt

export PROJECT_NAME="GT4Famix3-${PROJECT_VERSION}"

#save the date so we can show it in the download button
date +%s > releasedateinseconds

# customize the name of the build folder
export ARTIFACT_DIR="${PROJECT_NAME}"
mkdir "$ARTIFACT_DIR"
cp Pharo.image "${ARTIFACT_DIR}/${PROJECT_NAME}64.image"
cp Pharo.changes "${ARTIFACT_DIR}/${PROJECT_NAME}64.changes"
cp *.sources "${ARTIFACT_DIR}/"

export build_zip="${ARTIFACT_DIR}.zip"
zip -qr "$build_zip" "$ARTIFACT_DIR"

set +e
xvfb-run -a ./pharo "${ARTIFACT_DIR}/${PROJECT_NAME}64.image" st --quit scripts/icebergunconfig.st  2>&1
xvfb-run -a ./pharo "${ARTIFACT_DIR}/${PROJECT_NAME}64.image" eval --save 'IceRepository registry removeAll.'

git config --global user.name "Jenkins"
git config --global user.email "jenkins@feenk.com"


exit 0
