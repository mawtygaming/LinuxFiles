#!/bin/bash

TODAY=$(date +"%Y-%m-%d")

echo "Monthly back up of WOOH database."
echo "Backing up hoiylite database..." 
mysqldump -u root -p4332wurx --all-databases | gzip > /root/Monthly_Database/monthly_wooh_$TODAY.sql.gz
echo "Database has been backed up." 

find /root/Monthly_Database/ -mtime 120 -exec rm -R {} \;

# end script
