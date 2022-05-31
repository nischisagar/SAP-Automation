#!/bin/ksh
sidadm=`id -u -n`
sid1=`echo $sidadm|cut -c 4-6|tr '[a-z]' '[A-Z]'`
echo $sid1 > /tmp/$sidadm-sap-content-version.log
echo "MAXDB" >> /tmp/$sidadm-sap-content-version.log
dbmcli "db_enum"|grep -i $sid1|grep -i running|awk '{print $3}' >> /tmp/$sidadm-sap-content-version.log
