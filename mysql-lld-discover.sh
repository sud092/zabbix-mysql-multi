#!/bin/bash

## Zabbix Low level discovery script. 
## Returns a JSON array of port numbers used by mysqld instances.

res=`sudo /bin/netstat -lntp | awk '/mysqld/{print$4}' | sed "s/://g"`
#res=`/bin/netstat -lntp | awk '/mysqld/{print$4}' | sed 's/.*://'`

port=($res)

printf '{\n'

printf '\t\"data\":[\n\n'

for key in ${!port[@]}

do

	if [[ "${#port[@]}" -gt 1 && "${key}" -ne "$((${#port[@]}-1))" ]];then

		printf '\t{\n'

		printf "\t\t\"{#MYSQLPORT}\":\"${port[${key}]}\"},\n"

	else [[ "${key}" -eq "((${#port[@]}-1))" ]]

		printf '\t{\n'

		printf "\t\t\"{#MYSQLPORT}\":\"${port[${key}]}\"}\n"

	fi

done

printf '\n\t]\n'

printf '}\n'
