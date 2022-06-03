#!/bin/ksh
hostname > /tmp/smdrestart.txt
date >> /tmp/smdrestart.txt
run1=`find /usr/sap/*/*/script/ -name smdsetup.sh`
echo "run1=$run1" >> /tmp/smdrestart.txt
for i in $run1
do
agent=`echo $i|cut -d/ -f4|tr '[:upper:]' '[:lower:]'`
agtusr=$agent"adm"
echo "agtusr=$agtusr" >> /tmp/smdrestart.txt
smdno=`echo $i|cut -d/ -f5`
echo "smdno=$smdno" >> /tmp/smdrestart.txt
smno=`echo $i|cut -d/ -f5|cut -dA -f2`
echo "smno=$smno" >> /tmp/smdrestart.txt
smdpro=`ps -ef|grep -i startsrv|grep -i $agent|grep -v grep`
smdpid=`ps -ef|grep -i startsrv|grep -i $agent|grep -v grep|awk '{print $2}'`
echo "smdpro=$smdpro"  >> /tmp/smdrestart.txt
echo "smdpid=$smdpid" >> /tmp/smdrestart.txt
echo "stopping $smdno" >> /tmp/smdrestart.txt
su - $agtusr -c "stopsap $smdno"
echo "clean ipc $smno" >> /tmp/smdrestart.txt
su - $agtusr -c "cleanipc $smno -remove"
echo "killing pid $smdpid" >> /tmp/smdrestart.txt
su - $agtusr -c "kill $smdpid"
echo "Going for sleep 10 seconds" >> /tmp/smdrestart.txt
sleep 10
echo "starting $smdno" >> /tmp/smdrestart.txt
su - $agtusr -c "startsap $smdno"
smdcnt=`ps -ef|grep -i jc.sap|grep -i $smdno|grep -v grep|wc -l`
if [ $smdcnt -eq 1 ]
then
echo "SMD Agent $smdno startup is successful" >> /tmp/smdrestart.txt
else
echo "SMD Agent $smdno startup is not successful" >> /tmp/smdrestart.txt
fi
done

