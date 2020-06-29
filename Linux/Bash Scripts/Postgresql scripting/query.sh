#!/bin/bash

database="mawdb"

psql -d $database -c "SELECT mobile FROM account WHERE time=5"
