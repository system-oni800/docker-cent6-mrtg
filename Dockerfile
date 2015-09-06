FROM centos:centos6
MAINTAINER system-oni800

ENV IP _SET_YOUR_IP_ADDRESS_
ENV PW adminpass00
ENV MONITPW monitpass
ENV LOGSERVER _SET_MAGANER_AIP_

## Step01. set yum/rpm environment for mrtg
# Refresh
RUN yum clean all
RUN yum update -y -q
RUN yum install wget -y -q
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm 
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
# Install Zabbix release packages.
RUN yum install -y http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm

RUN rpm -ivh epel-release-6-8.noarch.rpm remi-release-6.rpm rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
ADD td.repo /etc/yum.repos.d/td.repo
RUN yum --enablerepo=remi,epel,treasuredata install sudo openssh-server syslog httpd httpd-devel monit td-agent net-snmp net-snmp-utils mrtg yum-cron patch -y -q
RUN localedef -f UTF-8 -i ja_JP ja_JP
RUN cp /etc/localtime /etc/localtime.org
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
ADD clock.txt /etc/sysconfig/clock

## Step02. set configuration files 
ADD monit.httpd /etc/monit.d/httpd
ADD monit.td-agent /etc/monit.d/td-agent
ADD monit.crond /etc/monit.d/crond
ADD monit.logging /etc/monit.d/logging
ADD monit.zabbix_agent /etc/monit.d/zabbix_agent

ADD httpd.conf /etc/httpd/conf/httpd.conf
ADD td-agent.conf /etc/td-agent/td-agent.conf
ADD monit.conf /etc/monit.conf
RUN chown -R root:root /etc/monit.d/ /etc/td-agent/td-agent.conf /etc/monit.conf
RUN chmod -R 600 /etc/monit.conf
RUN chkconfig crond on

## Step03. secure monit/td-agent environment
RUN sed -ri "s/%%IPADDRESS%%/$IP/" /etc/monit.conf
RUN sed -ri "s/%%PASSWORD%%/$MONITPW/" /etc/monit.conf
RUN sed -ri "s/__YOUR_LOG_SERVER_HERE__/$LOGSERVER/" /etc/td-agent/td-agent.conf

## Step04. snmp service start
ADD snmpd.conf /etc/snmp/snmpd.conf
RUN chkconfig snmpd on

## Step05. confgure mrtg environments.
RUN mv /etc/mrtg/mrtg.cfg /etc/mrtg/mrtg.cfg.org
ADD mrtg.cfg /etc/mrtg/mrtg.cfg
ADD mrtg.diff /root/mrtg.diff
RUN mkdir /var/log/mrtg

ADD set.sh /root/set.sh
ADD mk-mrtg.sh /root/mk-mrtg.sh
ADD mrtg.sh /root/mrtg.sh
RUN chmod 755 /root/set.sh /root/mk-mrtg.sh /root/mrtg.sh

## Step06. set httpd environments.
RUN mv /etc/httpd/conf.d/mrtg.conf /etc/httpd/conf.d/mrtg.conf.org
ADD mrtg-httpd.conf /etc/httpd/conf.d/mrtg.conf
RUN chmod 755 /var/log/httpd
RUN touch /etc/sysconfig/network

## Step07. zabbix-agent install
RUN yum install -y zabbix-agent
ADD zabbix_agentd.conf /etc/zabbix/izabbix_agentd.conf

## Step08. configure log rotate
ADD httpd.logrotated     /etc/logrotate.d/httpd
ADD monit.logrotated     /etc/logrotate.d/monit
ADD syslog.logrotated    /etc/logrptate.d/syslog
ADD td-agent.logrotated  /etc/logrptate.d/td-agent
RUN mkdir /var/log/archive

