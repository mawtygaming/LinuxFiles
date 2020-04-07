#! /bin/bash 

DATE=$(date +"%A %B-%d-%Y %r") 
COMMAND=$(/sbin/ifconfig ppp0 | grep 'inet' | cut -d: -f2 | awk '{print $2}') 
IPPATH=/home/pi/ipchecker/ipadd.txt 

echo "Hi VPMS Technical Team," > $IPPATH
echo "Good day!" >> $IPPATH
echo "This is the daily email of VPMS Cashier VPN IP Address." >> $IPPATH
echo "$DATE" >> $IPPATH
echo "Your VPMS Cashier VPN IP Address is: $COMMAND" >> $IPPATH 
mail -s "Daily VPMS Cashier VPN IP Address" omgroup@ideawurx.com.ph,jthermoso@sysnetph.com,jvcanto@sysnetph.com -aFrom:OMNGroup\<do-not-reply@sysnetph.com\> < $IPPATH

# STEPS
# Create a ipadd.txt on same directory
# chmod +x ipadd.sh - name of this bash script
# Test to run
# Add to cron job daily