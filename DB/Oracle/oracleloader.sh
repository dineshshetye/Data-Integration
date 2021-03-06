#!/bin/bash

arch=$(arch)

if [ $arch == "x86_64" ]
then
	sqlcmd="sqlplus64"
else
	sqlcmd="sqlplus"
fi

if [ $# -ge 5 ]
then
	user=$1
	pwd=$2
	host=$3
	service=$4
	`export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib:$LD_LIBRARY_PATH`
	`rm gen/exportscript.sql`
	#setup the exportscript template:
	cat gen/template >> gen/exportscript.sql
	#parse the rest of the arguments as table/path
	shift 4
	echo $1
	#while there are args left
	while [ "$1" ]
	do 
	exp="$1"
	table=${exp%,*}
	pat=${exp#*,}
	sh ./gen/sqlgen.sh $table $pat
	shift
	done
	printf 'EXIT' >> gen/exportscript.sql
	$sqlcmd $user/$pwd@$host/$service @gen/exportscript.sql
	scp gen/data/* hpccdemo@172.23.49.205:/var/lib/HPCCSystems/mydropzone/
else
	echo "This script needs to be run with the following arguments"
	echo "./oracleloader.sh username password hostname:port serviceid tablename1,path1 tablename2,path2 ..."
fi

