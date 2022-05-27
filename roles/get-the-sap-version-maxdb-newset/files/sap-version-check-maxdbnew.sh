#!/bin/ksh
sid=`env|grep -i SAPSYSTEMNAME|cut -d"=" -f2`
sidadm=`id -u -n`
batpath=`find /usr/sap/$sid/*/j2ee/configtool -name batchconfig.csh`
adssapv=`$batpath -task get.versions.of.deployed.units|grep -i adssap|head -1`
adsv=`echo $adssapv|cut -d: -f2|cut -d. -f2-3`
adsp=`echo $adssapv|cut -d: -f2|cut -d. -f4`
echo $sid > /tmp/$sidadm-sapads-maxdb-version.log
echo SAP NetWeaver $adsv SP $adsp >> /tmp/$sidadm-sapads-maxdb-version.log
disp+work|egrep -i 'variant|number' >> /tmp/$sidadm-sapads-maxdb-version.log
echo "MaxDB" >> /tmp/$sidadm-sapads-maxdb-version.log
cat /tmp/$sidadm-dbversion.txt|grep -i running|tail -1|awk '{print $3}' >> /tmp/$sidadm-sapads-maxdb-version.log
echo "100" >> /tmp/$sidadm-sapads-maxdb-version.log
