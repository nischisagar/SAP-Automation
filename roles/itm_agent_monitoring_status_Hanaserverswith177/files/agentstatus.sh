#!/bin/ksh
sid=`hdbsql -U hcuser  -j -x -C "select database_name from m_databases" | egrep -vi database_name`
SCHEMA=`hdbsql -U hcuser  -j -x -C "select schema_name from tables where table_name='USR02'" | egrep -vi schema_name`
agstatus=`hdbsql -U hcuser  -j -x -C "select UFLAG from $SCHEMA.usr02 where BNAME='IBMMON_AGENT' and MANDT='000'"|tail -1`
echo $sid > /tmp/itmuserstatus_hanadb
echo $agstatus >> /tmp/itmuserstatus_hanadb