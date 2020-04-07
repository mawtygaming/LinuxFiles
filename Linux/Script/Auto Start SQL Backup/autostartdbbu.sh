#! /bin/bash

export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`  # get the date today
DBPATH='/root/wooh_dbbackup'  # path
#HOST='localhost'
#PORT='3306'
USER='root'   #user
#PASSWORD='4332wurx'
DBNAME='wooh'   #database name
BACKUP_DAYS=5   # number of days


echo "Backing up database for today ${TODAY}"

mysqldump -u ${USER} -p ${PASSWORD} ${DBNAME} > ${DBPATH}/${DBNAME}-${TODAY}.sql


# end of script

