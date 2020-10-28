#!/bin/ksh
sid=`db2 -x "select current server from sysibm.sysdummy1"`
SCHEMA=`db2 -x "select tabschema from syscat.tables where tabname='CVERS_TXT'"`
sapvers=`db2 -x "select distinct varchar(STEXT,25) from $SCHEMA.CVERS_TXT where LANGU='E'"`
echo "SID         : $sid"
echo "SAP Version : $sapvers"
disp+work|egrep -i 'variant|number'