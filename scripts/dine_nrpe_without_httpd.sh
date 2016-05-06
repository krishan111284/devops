#!/bin/bash

NRPE=`cat /usr/local/nagios/etc/nrpe.cfg |grep allowed_hosts | awk -F'[=]' '{print $2}'`

cd /usr/local/nagios/etc/
cat nrpe.cfg |grep 192.169.30.156
if [ $? -ne 0 ]; then
sed -i s/$NRPE/$NRPE,192.169.30.156/g /usr/local/nagios/etc/nrpe.cfg
kill -9 `ps aux |grep -v grep | grep nrpe.cfg | awk '{print $2}'`
/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d
fi
