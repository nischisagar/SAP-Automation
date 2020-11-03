#!/bin/ksh
sid=`db2 -x "select current server from sysibm.sysdummy1"`
ssmall=`echo $sid|tr '[:upper:]' '[:lower:]'`
sidadm="${ssmall}adm"
SCHEMA=`db2 -x "select tabschema from syscat.tables where tabname='CVERS_TXT'"`
sapvers=`db2 -x "select distinct varchar(STEXT,25) from $SCHEMA.CVERS_TXT where LANGU='E'"`
dblevel=`db2level | grep token | awk '{print $4 " " $5}' | sed 's/"//g' |  sed 's/,//g'`
kernellevel=`db2 -x  "select SAPRELEASE,Trim(Leading '0' from patchno),timestamp from $SCHEMA.PATCHHIST where EXECUTABLE='disp+work' order by 3" | awk '{print $1 " " $2}' | tail -1`
echo "$sid" > /tmp/$sidadm-sap-version-check-db2-abap.log
echo "$sapvers" >> /tmp/$sidadm-sap-version-check-db2-abap.log
echo "$kernellevel" >> /tmp/$sidadm-sap-version-check-db2-abap.log
echo "$dblevel" >> /tmp/$sidadm-sap-version-check-db2-abap.log