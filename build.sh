#/bin/sh
echo "[STEP-01] Docker build.."
date
docker build --no-cache=true --rm -t centos6:mrtg .
date
exit
