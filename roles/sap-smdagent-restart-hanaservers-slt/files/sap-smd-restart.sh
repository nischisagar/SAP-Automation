#!/bin/bash
hname=`hostname`
source .sapenv_$hname.sh
stopsap SMDA97;sleep 5;startsap SMDA97 
