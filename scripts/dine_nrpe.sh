#!/bin/bash

NRPE=`cat /usr/local/nagios/etc/nrpe.cfg |grep allowed_hosts | awk -F'[=]' '{print $2}'`

cd /usr/local/nagios/etc/
cat nrpe.cfg |grep 192.169.30.156
if [ $? -ne 0 ]; then
sed -i s/$NRPE/$NRPE,192.169.30.156/g /usr/local/nagios/etc/nrpe.cfg
kill -9 `ps aux |grep -v grep | grep nrpe.cfg | awk '{print $2}'`
/usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d
fi

cd /etc/httpd/conf.d
ALLOW=`cat monitor.conf |grep "Allow from"`
cat monitor.conf |grep 127.0.0.1
if [ $? -ne 0 ]; then
sed -i "s/$ALLOW/$ALLOW 127.0.0.1/g" monitor.conf
service httpd reload
fi

cd /etc/httpd/conf/
HTTPDALL=`cat httpd.conf |grep "Allow from 192"`
cat httpd.conf |grep 127.0.0.1
if [ $? -ne 0 ]; then
sed -i "s#$HTTPDALL#$HTTPDALL 127.0.0.1#g" httpd.conf
service httpd reload
fi
