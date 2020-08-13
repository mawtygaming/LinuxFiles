#!/usr/bin/env bash

HOSTNAME='10.10.24.18'
USERNAME='postgres'
PASSWORD='uGxEbkJKcPRnzgxHXOJy'
DATABASE='appvno'
DATE=$(date +"%Y-%m-%d")

# Note that we are setting the password to a global environment variable temporarily.
echo "Pulling Database: This may take a few minutes"
export PGPASSWORD="$PASSWORD"
pg_dump -F t -h $HOSTNAME -U $USERNAME $DATABASE > /home/ec2-user/appvno_$DATE.backup
unset PGPASSWORD
echo "Pull Complete"
