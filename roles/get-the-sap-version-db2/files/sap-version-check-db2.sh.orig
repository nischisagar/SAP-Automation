#!/bin/ksh
sid=`db2 -x "select current server from sysibm.sysdummy1"`
SCHEMA=`db2 -x "select tabschema from syscat.tables where tabname='CVERS_TXT'"`
sapvers=`db2 -x "select distinct varchar(STEXT,25) from $SCHEMA.CVERS_TXT where LANGU='E'"`
dblevel=`db2level | grep token | awk '{print $4 " " $5}' | sed 's/"//g' |  sed 's/,//g'`
echo "$sid" > /tmp/sap-version-check-db2.log
echo "$sapvers" >> /tmp/sap-version-check-db2.log
disp+work|egrep -i 'variant|number' >> /tmp/sap-version-check-db2.log
echo "$dblevel" >> /tmp/sap-version-check-db2.log