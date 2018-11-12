#!/bin/bash -x

docker run -itd --name mrtg --privileged \
	-p 12812:2812 -p 8080:80 -p 8022:22 \
	-v /var/data/mrtg:/var/mrtg \
	centos7:mrtg \
	/usr/bin/monit -I
#
sleep 3
docker ps -a

