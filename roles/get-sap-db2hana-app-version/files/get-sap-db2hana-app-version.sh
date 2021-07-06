#!/bin/ksh
rm -f /ansible/reports/outputfinal.csv
tgtlist=`cat /ansible/reports/serverlist.txt|awk '{print $1}'|uniq`
ddate=`date +%Y-%m-%d`
#csvfile=`ls -lrt /ansible/reports/sap-db-versions-unix-linux-test-$ddate.csv|awk '{print $9}'`
csvfile=`ls -lrt /ansible/reports/sap_db2_abap_host_name.csv|awk '{print $9}'`
echo $csvfile
echo $tgtlist
for i in $tgtlist
do
echo $i
srcsid=`cat $csvfile|grep -v skp2|grep -v xmpsa013pbw0|grep -i $i`
echo $srcsid
echo $srcsid > /ansible/reports/temp1.csv
srchname=`cat /ansible/reports/temp1.csv|cut -d, -f2`
echo $srchname
updlist=`cat /ansible/reports/serverlist.txt|grep -i $i|awk '{print $3}'`
echo $updlist
for j in $updlist
do
echo $srchname
echo $j
value=`sed "s/$srchname/$j/g" /ansible/reports/temp1.csv`
echo $value
echo $value >> /ansible/reports/outputfinal.csv
done
done
#cat /ansible/reports/outputfinal.csv >> $csvfile