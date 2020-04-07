# /bin/bash 
# This script to check every 30 minutes if the VPN IP Address changed

GETIP=$(/sbin/ifconfig enp1s0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')
NEWIP=/home/vpms-rufino/ipchecker/new.txt 
LASTIP=/home/vpms-rufino/ipchecker/last.txt 
VPNCHANGE=/home/vpms-rufino/ipchecker/vpnchange.txt TIME=$(date +"%r") 


echo "$GETIP" > $NEWIP 

if cmp -s $NEWIP $LASTIP; then
	echo "Boss parehas lang." 
else
	echo "Hi VPMS Technical Team,\nGood day!\nAs of $TIME the VPN IP Address has changed into $GETIP.\nThank you so much!" > $VPNCHANGE
	mail -s "VPMS VPN IP Monitoring" wlbesa@sysnetph.com -aFrom:OMNGroup\<do-not-reply@sysnetph.com\> < $VPNCHANGE
	sleep 5s
	echo "$GETIP" > $LASTIP 
fi

# STEPS
# Create a new.txt file on same directory
# Create a last.txt file on same directory
# Add some text to last.txt 
# Create a vpnchange.txt file on same directory
# Test if working
# Add to cron job every 30 minutes

# Please take note that using echo > mean overwrite the existing file.
# While echo >> put the sentence on the bottom line.