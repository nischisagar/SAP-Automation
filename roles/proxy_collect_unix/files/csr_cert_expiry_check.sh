#!/bin/ksh
hname=`hostname`
cerf="$hname"_net.cer
openssl x509 -enddate -noout -in /usr/sap/hostctrl/exe/sec/$cerf > /tmp/certexp.txt
eyear=`cat /tmp/certexp.txt|grep -i NotAfter|awk '{print $4}'`
cyear=`date +%d:%m:%Y|cut -d: -f3`
dyear=`expr $eyear - $cyear`
if [ $dyear -ge 2 ]
then
        echo "Certificate has more than or equilavent of 2 year of validity: $dyear Years" > /tmp/csr_cert_exp_status.log
        echo "GREEN" >> /tmp/csr_cert_exp_status.log
elif [ $dyear -eq 1 ]
then
        emon=`cat /tmp/certexp.txt|grep -i NotAfter|cut -d= -f2|awk '{print $1}'`
        eminN1=`cat m.txt|grep -i $emon|awk '{print $1}'`
        cminN=`date +%d:%m:%Y|cut -d: -f2`
        if [ $cminN -gt 10 ] && [ $eminN1 -lt 4 ]
        then
                eminN=`cat m.txt|grep -i $emon|awk '{print $5}'`
                xminN=`expr $eminN - $cminN`
                echo "Critical:Certificate expire in Less than or equivalent to 3 Months: $xminN months" > /tmp/csr_cert_exp_status.log
                echo "YELLOW" >> /tmp/csr_cert_exp_status.log
        else
                echo "Certificate has more than 3 months of Validity" > /tmp/csr_cert_exp_status.log
                echo "GREEN" >> /tmp/csr_cert_exp_status.log
        fi
elif [ $dyear -eq 0 ]
then
        echo "cerficate expires in this year"
        echo "Finding certificate expiry month"
        emon=`cat /tmp/certexp.txt|grep -i NotAfter|cut -d= -f2|awk '{print $1}'`
        eminN=`cat m.txt|grep -i $emon|awk '{print $1}'`
        cminN=`date +%d:%m:%Y|cut -d: -f2`
        dminN=`expr $eminN - $cminN`
        edays=`cat /tmp/certexp.txt|grep -i NotAfter|cut -d= -f2|awk '{print $2}'`
        if [ $eminN -gt $cminN ]
        then
                if [ $dminN -gt 3 ]
                then
                        echo "Certificate has more than 3 months of Validity: $dminN Months" > /tmp/csr_cert_exp_status.log
                        echo "GREEN" >> /tmp/csr_cert_exp_status.log
                else
                        echo "Critical:Certificate expire in Less than or equivalent to 3 Months: $emon $edays" > /tmp/csr_cert_exp_status.log
                        echo "YELLOW" >> /tmp/csr_cert_exp_status.log
                fi
        elif [ $dminN -eq 0 ]
        then
                edays=`cat /tmp/certexp.txt|grep -i NotAfter|cut -d= -f2|awk '{print $2}'`
                cdays=`date +%d:%m:%Y|cut -d: -f1`
                ddays=`expr $edays - $cdays`
                if [ $ddays -lt 0 ]
                then
                        echo "Error:Certificate already expired on : $emon $edays" > /tmp/csr_cert_exp_status.log
                        echo "BLACK" >> /tmp/csr_cert_exp_status.log
                else
                        echo "Fatal: Certificate expiring by this Month: $emon in $ddays Days" > /tmp/csr_cert_exp_status.log
                        echo "RED" >> /tmp/csr_cert_exp_status.log
                fi
        else
                echo "Error:Certificate already expired on : $emon $edays" > /tmp/csr_cert_exp_status.log
                echo "BLACK" >> /tmp/csr_cert_exp_status.log
        fi
else
        echo "Error:Certificate already expired on : $eyear" > /tmp/csr_cert_exp_status.log
        echo "BLACK" >> /tmp/csr_cert_exp_status.log
fi