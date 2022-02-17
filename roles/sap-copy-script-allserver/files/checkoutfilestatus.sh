#!/bin/ksh
destpath="/exploit/scripts/sap/mutex_lock_monitoring"
offstatus=`cat $destpath/lockstatusfile.txt`
if [ $offstatus -eq 0 ]
then
        min=`find $destpath -name mutex_lock.txt -mmin +5 -exec ls -l '{}' \;|wc -l`
        if [ $min -eq 1 ]
        then
                echo "" > $destpath/mutex_lock.txt
                echo "1" > $destpath/lockstatusfile.txt
        else
                echo "File not 20 mins older" > $destpath/tempout.txt
        fi
else
        echo "No Deadlock error occurred in the system" > $destpath/tempout.txt
fi

