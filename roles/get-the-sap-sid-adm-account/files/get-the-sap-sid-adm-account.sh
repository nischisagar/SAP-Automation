#!/bin/ksh
sid="{{ QNE }}"
ssmall=`echo $sid|tr '[:upper:]' '[:lower:]'`
sidadm="${ssmall}adm"
echo "The admin user name of $sid  is $sidadm"