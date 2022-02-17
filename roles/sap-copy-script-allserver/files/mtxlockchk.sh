#/bin/ksh
destpath="/exploit/scripts/sap/mutex_lock_monitoring"
disppath=`find /usr/sap/*/*/work -name dev_disp`
for i in $disppath
do
echo $i
if [ `grep -i mtxlock $i|grep -i deadlock|wc -l` -gt 0 ]
then
echo "mutex lock occured" > $destpath/mutex_lock.txt
sid=`echo $i|cut -d/ -f4`
echo $sid >> $destpath/mutex_track_history.txt
date >> $destpath/mutex_track_history.txt
grep -i mtxlock $i|grep -i deadlock >> $destpath/mutex_track_history.txt
echo 0 > $destpath/lockstatusfile.txt
else
echo "no lock error" > $destpath/noerror.txt
fi
done
