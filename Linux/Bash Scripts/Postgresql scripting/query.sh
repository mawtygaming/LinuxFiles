#!/bin/bash

database="mawdb"

psql -d $database -c "SELECT * FROM account WHERE time=5"
