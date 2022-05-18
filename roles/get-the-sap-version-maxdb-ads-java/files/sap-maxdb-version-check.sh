#!/bin/ksh
sid=`env|grep -i SAPSYSTEMNAME|cut -d"=" -f2`
dbmcli -d $sid -U w <<EOF
db_enum
exit
EOF
