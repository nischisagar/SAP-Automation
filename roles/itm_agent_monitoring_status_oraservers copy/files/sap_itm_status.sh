#!/bin/ksh
rm -f /tmp/sidfile_temp.txt /tmp/sidlist_upd.txt /tmp/itmuserlist.txt
df -g|grep -i /sapmnt/|awk '{print $NF}'|cut -d/ -f3 > /tmp/sidfile_temp.txt
for j in `cat /tmp/sidfile_temp.txt`
do
        systype=`cat /sapmnt/$j/profile/DEFAULT.PFL|grep -i "system/type"|awk '{print $3}'`
        echo "$systype $j" >> /tmp/sidlist_upd.txt
done
cat /tmp/sidlist_upd.txt|sort -r|grep -v J2EE|awk '{print $2}' > /tmp/itmuserlist.txt
for k in `cat /tmp/itmuserlist.txt`
do
        sadm1=`echo $k|tr '[A-Z]' '[a-z]'`
        sadm=$sadm1"adm"
        echo $sadm
su - $sadm -c '/exploit/SAP/sql1.sh'
sed '/^$/d' /tmp/itmuserstatus.txt|tr -d ' ' > /tmp/itmuserstatus_$k.txt
rm -f /tmp/itmuserstatus.txt
cnt=`/opt/IBM/ITM/bin/cinfo -r|grep -i $k|wc -l|tr -d ' '`
if [ $cnt -eq 1 ]
then
        echo ""$k"_sa_itm_Running" >> /tmp/itmuserstatus_$k.txt
else
        echo "$k_sa_itm_NotRunning" >> /tmp/itmuserstatus_$k.txt
fi
done

cnt1=`/opt/IBM/ITM/bin/cinfo -r|grep -i ux|wc -l|tr -d ' '`
if [ $cnt1 -eq 1 ]
then
        /opt/IBM/ITM/bin/cinfo -r|grep -i ux|awk '{print $2_$7}' >> /tmp/itmuserstatus_$k.txt
else
        echo "UNIX_itm_NotRunning" >> /tmp/itmuserstatus_$k.txt
fi
done

itmuser_cnt=`cat /tmp/itmuserlist.txt|wc -l|awk '{print $0}'`
userdiff=`expr 5 - $itmuser_cnt`
k=0
while let "(k=$k+1) <= $userdiff"
do
echo "dummy" >> /tmp/itmuserlist.txt
done
echo "dummy" > /tmp/dummy_csr_cert_exp_status.log