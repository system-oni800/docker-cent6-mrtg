#!/bin/bash -x
sleep 2

systemctl enable httpd
systemctl enable snmpd.service
systemctl enable monit

systemctl start httpd
systemctl status -l httpd

IP=$(ip addr list eth0 | grep "inet " | cut -d' ' -f6 | cut -d/ -f1)
echo "ip address = $IP"
sed -ri "s/%%IPADDRESS%%/$IP/" /etc/snmp/snmpd.conf
sed -ri "s/%%IPADDRESS%%/$IP/" /root/mk-mrtg.sh
cat /etc/snmp/snmpd.conf | grep mynetwork
cat /root/mk-mrtg.sh | grep cfgmaker
echo "## Start snmp service.."
systemctl start snmpd.service
systemctl status -l snmpd.service

sleep 1

systemctl start monit

echo "## Check snmpwalk at $IP."
snmpwalk -v 2c -c public $IP | head -10

#sed -ri "s/%%IPADDRESS%%/$IP/" /root/mk-mrtg.sh
echo "## Start mrtg configuration .. "
/root/mk-mrtg.sh

