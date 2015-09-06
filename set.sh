#!/bin/bash
sleep 2

IP=$(ip addr list eth0 | grep "inet " | cut -d' ' -f6 | cut -d/ -f1)
echo "ip address = $IP"
sed -ri "s/%%IPADDRESS%%/$IP/" /etc/snmp/snmpd.conf
sed -ri "s/%%IPADDRESS%%/$IP/" /root/mk-mrtg.sh
cat /etc/snmp/snmpd.conf | grep mynetwork
cat /root/mk-mrtg.sh | grep cfgmaker
echo "Start snmp service.."
service snmpd start
chkconfig snmpd on
sleep 1

echo "Check snmpwalk at $IP."
snmpwalk -v 2c -c public $IP | head -10

#sed -ri "s/%%IPADDRESS%%/$IP/" /root/mk-mrtg.sh
echo "Start mrtg configuration .. "
/root/mk-mrtg.sh

