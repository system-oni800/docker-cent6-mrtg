#!/bin/bash

LOCK=/var/lock/mrtg
CONF=/etc/mrtg
LOG=/var/log/mrtg

LANG=C LC_ALL=C /usr/bin/mrtg $CONF/mrtg.cfg --lock-file $LOCK/mrtg_l --confcache-file $CONF/script/mrtg.ok > $LOG/mrtg.log 2>&1

