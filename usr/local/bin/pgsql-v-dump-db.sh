#!/bin/bash

#
# Released under MIT License
# Copyright (c) 2019-2024 Jose Manuel Churro Carvalho
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
    echo "postgres dump database (using supplied version)"
    echo "Usage: pgsql-v-dump-db.sh <version (ex: 13, 14, 15, 16, etc ...)> <database name> <database username> <server> <port> <dump filename>"
}

if [ "$6" = "" ]; then
    usage
    exit 2
fi

PGSQLVERSION="$1"
DBNAME="$2"
DBUSERNAME="$3"
SERVERNAME="$4"
PORT="$5"
DUMPFILENAME="$6".gz

/usr/pgsql-"$PGSQLVERSION"/bin/pg_dump -U "$DBUSERNAME" -h "$SERVERNAME" -p "$PORT" -Fc "$DBNAME" | gzip > "$DUMPFILENAME"
retvalue=$?

exit "$retvalue"

