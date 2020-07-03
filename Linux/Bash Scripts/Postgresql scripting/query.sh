#!/bin/bash

database="mawdb"

psql -d $database -c "SELECT mobile FROM account WHERE time=5"



bash
now=$(date '+%b %d %Y  %H:%M:%S')

python
from datetime import datetime

now = datetime.now()
currentTime = now.strftime("%B %d %Y %H:%M:%S")
print("[{0}]".format(currentTime))