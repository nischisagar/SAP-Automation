#!/bin/ksh
hname=`hostname`
#cerf="$hname"_net.cer
#cerlist=`ls -lrt /usr/sap/csr_cert/*.cer|awk '{print $NF}'|cut -d/ -f5`
rm -f /tmp/*_csr_cert_exp_status.log
ls -lrt /usr/sap/csr_cert/*.cer|awk '{print $NF}'|cut -d/ -f5 > /tmp/cerlist.txt
for i in `cat /tmp/cerlist.txt`
do
openssl x509 -enddate -noout -in /usr/sap/csr_cert/$i > /tmp/certexp.txt
cerexpdate=`cat /tmp/certexp.txt|cut -d= -f2`
eyear=`cat /tmp/certexp.txt|grep -i NotAfter|awk '{print $4}'`
cyear=`date +%d:%m:%Y|cut -d: -f3`
dyear=`expr $eyear - $cyear`
certtype=`ls -lrt /usr/sap/csr_cert/$i|grep -i frun|wc -l`
if [ $certtype -eq 1 ]
then
        echo "FocusRun Certificate" >> /tmp/"$i"_csr_cert_exp_status.log
else
        echo "ABAP-Java Certificate" >> /tmp/"$i"_csr_cert_exp_status.log
fi
if [ $dyear -ge 2 ]
then
        echo $i >> /tmp/"$i"_csr_cert_exp_status.log
        echo "Certificate has more than or equilavent of 2 year of validity" >> /tmp/"$i"_csr_cert_exp_status.log
        echo "GREEN" >> /tmp/"$i"_csr_cert_exp_status.log
        echo "$cerexpdate" >> /tmp/"$i"_csr_cert_exp_status.log
elif [ $dyear -eq 1 ]
then
        emon=`cat /tmp/certexp.txt|grep -i NotAfter|cut -d= -f2|awk '{print $1}'`
        eminN1=`cat /tmp/m.txt|grep -i $emon|awk '{print $1}'`
        cminN=`date +%d:%m:%Y|cut -d: -f2`
        if [ $cminN -gt 10 ] && [ $eminN1 -lt 4 ]
        then
                eminN=`cat /tmp/m.txt|grep -i $emon|awk '{print $5}'`
                xminN=`expr $eminN - $cminN`
                echo $i >> /tmp/"$i"_csr_cert_exp_status.log
                echo "Critical:Certificate expire in Less than or equivalent to 3 Months" >> /tmp/"$i"_csr_cert_exp_status.log
                echo "YELLOW" >> /tmp/"$i"_csr_cert_exp_status.log
                echo "$cerexpdate" >> /tmp/"$i"_csr_cert_exp_status.log
        else
                echo $i >> /tmp/"$i"_csr_cert_exp_status.log
                echo "Certificate has more than 3 months of Validity" >> /tmp/"$i"_csr_cert_exp_status.log
                echo "GREEN" >> /tmp/"$i"_csr_cert_exp_status.log
                echo "$cerexpdate" >> /tmp/"$i"_csr_cert_exp_status.log
        fi
elif [ $dyear -eq 0 ]
then
        echo "cerficate expires in this year"
        echo "Finding certificate expiry month"
        emon=`cat /tmp/certexp.txt|grep -i NotAfter|cut -d= -f2|awk '{print $1}'`
        eminN=`cat /tmp/m.txt|grep -i $emon|awk '{print $1}'`
        cminN=`date +%d:%m:%Y|cut -d: -f2`
        dminN=`expr $eminN - $cminN`
        edays=`cat /tmp/certexp.txt|grep -i NotAfter|cut -d= -f2|awk '{print $2}'`
        if [ $eminN -gt $cminN ]
        then
                if [ $dminN -gt 3 ]
                then
                        echo $i >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "Certificate has more than 3 months of Validity" >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "GREEN" >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "$cerexpdate" >> /tmp/"$i"_csr_cert_exp_status.log
                else
                        echo $i >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "Critical:Certificate expire in Less than or equivalent to 3 Months: $emon $edays" >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "YELLOW" >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "$cerexpdate" >> /tmp/"$i"_csr_cert_exp_status.log
                fi
        elif [ $dminN -eq 0 ]
        then
                edays=`cat /tmp/certexp.txt|grep -i NotAfter|cut -d= -f2|awk '{print $2}'`
                cdays=`date +%d:%m:%Y|cut -d: -f1`
                ddays=`expr $edays - $cdays`
                if [ $ddays -lt 0 ]
                then
                        echo "Error:Certificate already expired on : $emon $edays" >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "BLACK" >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "$cerexpdate" >> /tmp/"$i"_csr_cert_exp_status.log
                else
                        echo "Fatal: Certificate expiring by this Month: $emon in $ddays Days" >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "RED" >> /tmp/"$i"_csr_cert_exp_status.log
                        echo "$cerexpdate" >> /tmp/"$i"_csr_cert_exp_status.log
                fi
        else
                echo "Error:Certificate already expired on : $emon $edays" >> /tmp/"$i"_csr_cert_exp_status.log
                echo "BLACK" >> /tmp/"$i"_csr_cert_exp_status.log
                echo "$cerexpdate" >> /tmp/"$i"_csr_cert_exp_status.log
        fi
else
        echo "Error:Certificate already expired on : $eyear" >> /tmp/"$i"_csr_cert_exp_status.log
        echo "BLACK" >> /tmp/"$i"_csr_cert_exp_status.log
        echo "$cerexpdate" >> /tmp/"$i"_csr_cert_exp_status.log
fi
done
    cert_cnt=`cat /tmp/cerlist.txt|wc -l|awk '{print $0}'`
    userdiff=`expr 6 - $cert_cnt`
    k=0
    while let "(k=$k+1) <= $userdiff"
    do
    echo "dummy" >> /tmp/cerlist.txt
    done
    echo "dummy" > /tmp/dummy_csr_cert_exp_status.log