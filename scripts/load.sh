#/bin/sh!
set -o xtrace

curl https://get.pharo.org/64/stable+vm | bash
xvfb-run -a ./pharo Pharo.image st --quit scripts/icebergconfig.st  2>&1
xvfb-run -a ./pharo Pharo.image st --quit scripts/loadgt4famix3.st 2>&1
exit 0