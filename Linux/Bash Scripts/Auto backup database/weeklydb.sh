#! /bin/bash

TODAY=$(date +"%Y-%m-%d")

echo "Weekly back up of WOOH database."
echo "Backing up hoiylite database..." 
mysqldump -u root -p4332wurx --all-databases | gzip > /root/Weekly_Database/weekly_wooh_$TODAY.sql.gz
echo "Database has been backed up." 

find /root/Weekly_Database/ -mtime 60 -exec rm -R {} \;

# end script
