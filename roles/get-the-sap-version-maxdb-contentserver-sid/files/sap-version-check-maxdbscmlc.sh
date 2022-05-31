#!/bin/ksh
sidadm=`id -u -n`
sid1=`df -g|grep -i sapdb|grep -i saplog|grep -v logbackup|grep -v saplogbck|awk '{print $NF}'|cut -d/ -f3`
echo $sid1 > /tmp/$sidadm-sapscm-lc-version.log
echo "MAXDB" >> /tmp/$sidadm-sapscm-lc-version.log
dbmcli -d $sid1 -c "db_enum"|grep -i running|awk '{print $3}' >> /tmp/$sidadm-sapscm-lc-version.log
