#!/bin/ksh
sid=`db2 -x "select current server from sysibm.sysdummy1"`
SCHEMA=`db2 -x "select tabschema from syscat.tables where tabname='CVERS_TXT'"`
sapvers=`db2 -x "select distinct varchar(STEXT,25) from $SCHEMA.CVERS_TXT where LANGU='E'"`
echo "$sid" > /tmp/sap-version-check.log
echo "$sapvers" >> /tmp/sap-version-check.log
disp+work|egrep -i 'variant|number' >> /tmp/sap-version-check.log