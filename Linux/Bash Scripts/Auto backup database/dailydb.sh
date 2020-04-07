#! /bin/bash

TODAY=$(date +"%Y-%m-%d_%H-%M")

echo "Daily back up of WOOH database."
echo "Backing up hoiylite database..." 
mysqldump -u root -p4332wurx --all-databases | gzip > /root/Daily_Database/wooh_$TODAY.sql.gz
echo "Database has been backed up." 

# This line will check if the directly has 7 or more days older and delete it
find /root/Daily_Database/ -mtime 7 -exec rm -R {} \;

# end script
