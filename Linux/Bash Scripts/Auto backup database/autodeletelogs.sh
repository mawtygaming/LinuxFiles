#!/bin/bash

# registration
find /data/logs/registration -mtime 180 -exec rm -R {} \;
# subscriberinfo
find /data/logs/subscriberinfo -mtime 180 -exec rm -R {} \;
# voice call
find /data/logs/voicecall -mtime 180 -exec rm -R {} \;
# profile
find /data/logs/profile -mtime 180 -exec rm -R {} \;
# top up
find /data/logs/topup -mtime 180 -exec rm -R {} \;
# svn
find /data/logs/svn -mtime 180 -exec rm -R {} \;
# pin management
find /data/logs/pinmanagement -mtime 180 -exec rm -R {} \;
# login
find /data/logs/login -mtime 180 -exec rm -R {} \;
# auth module
find /data/logs/authmodule -mtime 180 -exec rm -R {} \;

# end of script