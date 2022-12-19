#!/bin/ksh
rm -f /tmp/sidfileitm /tmp/schemafileitm /tmp/resultitm.txt /tmp/itmuserstatus_maxdb_tmp.txt
sidadm=`id -u -n`
sqlcli -U DEFAULT <<EOF
\output /tmp/sidfileitm
select serverdb from domain.users
exit
EOF
sid=`cat /tmp/sidfileitm|sed 's/|//g'|tail -1`
sqlcli -d $sid -U DEFAULT <<EOF
\output /tmp/schemafileitm
select schemaname from tables where tablename='CVERS_TXT'
exit
EOF
schema=`cat /tmp/schemafileitm|sed 's/|/ /g'|tail -1`
echo "schema = $schema"
sqlcli -d $sid -U DEFAULT <<EOF
\output /tmp/resultitm.txt
select distinct serverdb from domain.users
select UFLAG from $schema.usr02 where BNAME='IBMMON_AGENT' and MANDT='000'
exit
EOF
cat /tmp/resultitm.txt|sed 's/|/ /g'|head -3|tail -1 > /tmp/itmuserstatus_maxdb_tmp.txt
cat /tmp/resultitm.txt|sed 's/|/ /g'|tail -1 >> /tmp/itmuserstatus_maxdb_tmp.txt
cat /tmp/itmuserstatus_maxdb_tmp.txt|tr -d ' ' > /tmp/itmuserstatus_maxdb.txt

k=`cat /tmp/itmuserstatus_maxdb.txt|head -1`
cnt=`/opt/IBM/ITM/bin/cinfo -r|grep -i $k|grep -i running|wc -l|tr -d ' '`

if [ $cnt -eq 1 ]
then
#echo ""$k"_sa_itm_Running" >> /tmp/itmuserstatus_maxdb.txt
/opt/IBM/ITM/bin/cinfo -r|grep -i $k|grep -i running|awk '{print $6_$2_$7}' >> /tmp/itmuserstatus_maxdb.txt
else
echo ""$k"_sa_itm_NotRunning" >> /tmp/itmuserstatus_maxdb.txt
fi

cnt1=`/opt/IBM/ITM/bin/cinfo -r|grep -iE 'ux|lz'|grep -i running|wc -l|tr -d ' '`
if [ $cnt1 -eq 1 ]
then
/opt/IBM/ITM/bin/cinfo -r|grep -iE 'ux|lz'|awk '{print $2_$7}' >> /tmp/itmuserstatus_maxdb.txt
else
echo "OS_ITM_Agent_NotRunning" >> /tmp/itmuserstatus_maxdb.txt
fi
