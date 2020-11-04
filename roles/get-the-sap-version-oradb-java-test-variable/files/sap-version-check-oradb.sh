#!/bin/ksh
sidadm=`id -u -n`
echo "$sidadm" > /tmp/$sidadm-sap-version-check-oradb.log