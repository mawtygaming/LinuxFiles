#! /bin/bash

export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`
DBPATH='/root/wooh_dbbackup'
DBPATH2='/root/wooh_table_macs'
#HOST='localhost'
#PORT='3306'
USER='root'
#PASSWORD='4332wurx'
DBNAME='wooh'
TABLENAME='report_macs'
BACKUP_DAYS=5


echo "Backing up database for today ${TODAY}"

mysqldump -u ${USER} -p ${PASSWORD} ${DBNAME} > ${DBPATH}/${DBNAME}-${TODAY}.sql

echo "Backing report_macs table ${TODAY}"
mysqldump -u ${USER} -p ${PASSWORD} ${DBNAME} ${TABLENAME} > ${DBPATH2}/${TABLENAME}-${TODAY}.sql 


#auto delete every x days

find /root/wooh_dbbackup -mtime +5 -exec rm {} \;
find /root/wooh_table_macs -mtime +5 -exec rm {} \;

# end of script
