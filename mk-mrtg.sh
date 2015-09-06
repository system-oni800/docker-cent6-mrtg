#!/bin/bash

echo "Start script($0)."
# mkdir of mrtg contents on host directory mapping.
echo "Start mrtg html conents space."
\cp -rfp /var/www/mrtg /var/mrtg/html
mv /var/www/mrtg /var/www/mrtg-org
ln -s /var/mrtg/html /var/www/mrtg

# make mrtg configuration
echo "Start cfgmaker.."
cfgmaker --ifref=descr --ifdesc=descr public@%%IPADDRESS%% > /etc/mrtg/mrtg.cfg
ls -al /etc/mrtg
echo "And patch the config."
patch -p0 /etc/mrtg/mrtg.cfg < /root/mrtg.diff
cat -n /etc/mrtg/mrtg.cfg | grep Work

sleep 1
# start to make index file of mrtg page
echo "Start indexmaker.."
indexmaker --columns=1 /etc/mrtg/mrtg.cfg > /var/www/mrtg/index.html
mkdir /etc/mrtg/script

# set cron,script
sleep 60
echo "Copyinf files..and set cron, page cache."
cp /root/mrtg.sh /etc/mrtg/script/mrtg.sh
#cp /etc/mrtg/mrtg.ok /etc/mrtg/script/mrtg.ok
echo "*/5 * * * * root /etc/mrtg/script/mrtg.sh >> /var/log/mrtg/mrtg-cron.log 2>&1" > /etc/cron.d/mrtg

env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg

echo "Reload monit.."
monit reload
ps aux
cp /etc/mrtg/mrtg.ok /etc/mrtg/script/mrtg.ok
echo "End of script($0)."


