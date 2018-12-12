#!/bin/bash

# Title:: MySQL Low Level Discovery script
# License:: LGPL 2.1   http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
# Copyright:: Copyright (C) 2018 Matt Sansom
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

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
