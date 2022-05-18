#!/bin/ksh
sid=`df -g|grep -i sapdb|grep -i saplog|grep -v logbackup|awk '{print $NF}'|cut -d/ -f3`
dbmcli -d $sid -U w <<EOF
db_enum
exit
EOF
