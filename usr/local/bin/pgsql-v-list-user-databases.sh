#!/bin/bash

#
# Released under MIT License
# Copyright (c) 2018-2025 Jose Manuel Churro Carvalho
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
# and associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

usage()
{
    echo "postgres list user databases (using supplied version)"
    echo "Usage: pgsql-v-list-user-databases.sh <version (ex: 13, 14, 15, 16, etc ...)> <server> <port>"
}

if [ "$3" = "" ]; then
    usage
    exit 2
fi

PGSQLVERSION="$1"
SERVERNAME="$2"
PORT="$3"

dbnames=$(sudo -u postgres /usr/pgsql-"$PGSQLVERSION"/bin/psql postgres -t -h "$SERVERNAME" -p "$PORT" -c "select datname from pg_database where datistemplate = false and datname <> 'postgres';")
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit "$retvalue"
fi

for dbname in $dbnames; do
    echo "Using $dbname"
    echo "$dbname"
done

exit 0

