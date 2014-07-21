#!/bin/bash


printf "SPOOL gen/data/"$1.csv" REPLACE \n" >> gen/exportscript.sql

if [ $# -eq 2 ]
then
	cat $2 >> gen/exportscript.sql
else
	printf "SELECT * FROM "$1" \n" >> gen/exportscript.sql	
	
fi
printf "SPOOL OFF \n" >> gen/exportscript.sql
