#!/bin/ksh
sid=`/sapdb/programs/bin/dbmcli db_enum|grep -i running|awk '{print $1}'`
sidadm=`id -u -n`
/sapdb/programs/bin/sqlcli -d $sid -U hcuser <<EOF
\output schemafile
select schemaname from tables where tablename='CVERS_TXT'
exit
EOF
schema=`cat schemafile|sed 's/|/ /g'|tail -1`
echo "schema = $schema"
/sapdb/programs/bin/sqlcli -d $sid -U hcuser <<EOF
\output result.txt
select distinct STEXT from $schema.CVERS_TXT where LANGU='E'
select SAPRELEASE,ltrim(patchno,'0'),timestamp from $schema.PATCHHIST where EXECUTABLE='disp+work' order by 3
exit
EOF
Sapversion=`cat result.txt|sed 's/|/ /g'|head -3|tail -1|awk '{print $1,$2,$3}'`
Kernelversion=`cat result.txt|sed 's/|/ /g'|tail -1|awk '{print $1,$2}'`
DBversion=`/sapdb/programs/bin/dbmcli db_enum|grep -i running|awk '{print $3}'`
echo "$sid" > /tmp/$sidadm-sap-version-check-maxdb-abap.log
echo "$Sapversion" >> /tmp/$sidadm-sap-version-check-maxdb-abap.log
echo "$Kernelversion" >> /tmp/$sidadm-sap-version-check-maxdb-abap.log
echo "MaxDB $DBversion" >> /tmp/$sidadm-sap-version-check-maxdb-abap.log