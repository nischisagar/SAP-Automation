#!/bin/ksh
sid=`env|grep -i DB_SID|cut -d"=" -f2`
sidadm=`id -u -n`
schemaa=`env|grep -i dbs_ora_schema|cut -d"=" -f2`
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/$sidadm-ansible-psapsr3.log;
column HOST_NAME format a20
set linesize 300
set heading off;
select nam.INSTANCE_NAME, nam.HOST_NAME , df.Maxtotalspace as "Total Size(MB)" , round(df.Maxtotalspace - tu.totalusedspace) "Total Free(MB)", round(100 * ( (tu.totalusedspace)/ df.Maxtotalspace)) "Total Used %",df.tablespace_name from
(select tablespace_name,round(sum(bytes) / 1048576) TotalSpace , round(sum(MAXBYTES) / 1048576) Maxtotalspace from dba_data_files group by tablespace_name) df,
(select round(sum(bytes)/1048576) totalusedspace, tablespace_name from dba_segments group by tablespace_name) tu,
(select INSTANCE_NAME,HOST_NAME from V\$instance) nam
where df.tablespace_name = tu.tablespace_name and df.tablespace_name='PSAPSR3';
spool off;
set linesize 500;
set pagesize 500;
spool /tmp/$sidadm-ansible-dbsize.log;
select
( select sum(bytes)/1024/1024/1024 data_size from dba_data_files ) +
( select nvl(sum(bytes),0)/1024/1024/1024 temp_size from dba_temp_files ) +
( select sum(bytes)/1024/1024/1024 redo_size from sys.v_\$log ) +
( select sum(BLOCK_SIZE*FILE_SIZE_BLKS)/1024/1024/1024 controlfile_size from v\$controlfile) "Size in GB"
from
dual;
spool off;
exit
EOF
sid=`cat /tmp/$sidadm-ansible-psapsr3.log|awk '{print $1}'|head -2|tail -1`
hostname=`cat /tmp/$sidadm-ansible-psapsr3.log|awk '{print $2}'|head -2|tail -1`
totaltssize=`cat /tmp/$sidadm-ansible-psapsr3.log|awk '{print $3}'|head -2|tail -1`
totalfreespace=`cat /tmp/$sidadm-ansible-psapsr3.log|awk '{print $4}'|head -2|tail -1`
totalused=`cat /tmp/$sidadm-ansible-psapsr3.log|awk '{print $5}'|head -2|tail -1`
dbsize=`cat /tmp/$sidadm-ansible-dbsize.log|head -2|tail -1`
echo "$sid" > /tmp/$sidadm-psapsr3-ts-and-db-size-oradb-abap.log
echo "$hostname" >> /tmp/$sidadm-psapsr3-ts-and-db-size-oradb-abap.log
echo "$totaltssize" >> /tmp/$sidadm-psapsr3-ts-and-db-size-oradb-abap.log
echo "$totalfreespace" >> /tmp/$sidadm-psapsr3-ts-and-db-size-oradb-abap.log
echo "$totalused" >> /tmp/$sidadm-psapsr3-ts-and-db-size-oradb-abap.log
echo "$dbsize" >> /tmp/$sidadm-psapsr3-ts-and-db-size-oradb-abap.log