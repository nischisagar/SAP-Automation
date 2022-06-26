#!/bin/bash
hname=`hostname`
source .sapenv_$hname.sh
stopsap SMDA98;sleep 5;startsap SMDA98
