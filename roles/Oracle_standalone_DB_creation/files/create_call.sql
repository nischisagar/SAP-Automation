create database OTEST
  logfile   group 1 ('/oracle/OTEST/redolog/redo1.log') size 10M,
            group 2 ('/oracle/OTEST/redolog/redo2.log') size 10M,
            group 3 ('/oracle/OTEST/redolog/redo3.log') size 10M
  character set          WE8ISO8859P1
  national character set utf8
  datafile '/oracle/OTEST/oradata1/system.dbf'
            size 50M
            autoextend on
            next 10M maxsize unlimited
            extent management local
  sysaux datafile '/oracle/OTEST/oradata1/sysaux.dbf'
            size 10M
            autoextend on
            next 10M
            maxsize unlimited
  undo tablespace undo
            datafile '/oracle/OTEST/oradata1/undo.dbf'
            size 10M
  default temporary tablespace temp
            tempfile '/oracle/OTEST/oradata1/temp.dbf'
            size 10M;