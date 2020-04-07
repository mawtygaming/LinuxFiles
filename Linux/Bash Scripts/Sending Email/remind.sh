#! /bin/bash

LASTMONTH=$(date +'%B' -d 'last month') 
YEAR=$(date +%Y) 
REMIND=/root/remind.txt

rm $REMIND
sleep 1s 
touch $REMIND 
sleep 1s 
echo -e "Hi VPMS Technical Team,\nGood day!\nKindly copy the monthly backup database for the month of $LASTMONTH $YEAR.\nThank you so much!" > $REMIND

mail -s "WOOH Monthly Database Backup" wlbesa@sysnetph.com -aFrom:OMNGroup\<do-not-reply@sysnetph.com\> < $REMIND
# mail -s "WOOH Monthly Database Backup" omgroup@ideawurx.com.ph,jthermoso@sysnetph.com -aFrom:OMNGroup\<do-not-reply@sysnetph.com\> < $REMIND

# STEPS
# Create a remind.txt on same directory
# chmod +x remind.sh - name of this bash script
# Test to run
# Add to cron job monthly