#/bin/bash -x
echo "[STEP-00] Prepare for building.."
cp Dockerfile.org Dockerfile

echo $IP
sed -ri "s/_SET_IP_/$IP/" ./Dockerfile
echo "[STEP-01] Docker build.."
date
docker build  --no-cache=true --rm  -t centos7:mrtg .
date
exit
