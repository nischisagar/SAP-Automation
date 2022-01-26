export ORACLE_SID={{ dbname }}
export ORACLE_HOME={{ oracle_home_value }}
export ORACLE_BASE={{ oracle_base_value }}
export PATH={{ oracle_home_value }}/bin:$PATH
sqlplus -s sys/sys as sysdba<<EOF
startup nomount pfile='/oracle/stage/init_test.ora'
spool /oracle/stage/dbcreatestatus.txt
@/oracle/stage/create_call.sql
spool off
exit
EOF