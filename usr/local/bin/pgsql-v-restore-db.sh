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
    echo "postgres restore database (using supplied version)"
    echo "Usage: pgsql-v-restore-db.sh <version (ex: 13, 14, 15, 16, etc ...)> <database name> <database username> <server> <port> <dump filename with gz> <create role?> <password>"
}

if [ "$7" = "" ]; then
    usage
    exit 2
fi

PGSQLVERSION="$1"
DBNAME="$2"
DBUSERNAME="$3"
SERVERNAME="$4"
PORT="$5"
DUMPFILENAME="$6"
CREATEROLE="$7"
DBUSERPASSWORD="$8"

if [ "$CREATEROLE" = "1" ]; then
    if [ "$DBUSERPASSWORD" = "" ]; then
        usage
        exit 2
    fi
fi

sudo -u postgres /usr/pgsql-"$PGSQLVERSION"/bin/psql postgres -h "$SERVERNAME" -p "$PORT" -c "drop database if exists $DBNAME;"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit "$retvalue"
fi

if [ "$CREATEROLE" = "1" ]; then
    sudo -u postgres /usr/pgsql-"$PGSQLVERSION"/bin/psql postgres -h "$SERVERNAME" -p "$PORT" -c "create role $DBUSERNAME LOGIN password '$DBUSERPASSWORD';";
    retvalue=$?
    if [ "$retvalue" != "0" ]; then
        echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
        exit "$retvalue"
    fi
fi

sudo -u postgres /usr/pgsql-"$PGSQLVERSION"/bin/psql postgres -h "$SERVERNAME" -p "$PORT" -c "create database $DBNAME with template 'template0' encoding 'UTF8';"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit "$retvalue"
fi

sudo -u postgres /usr/pgsql-"$PGSQLVERSION"/bin/psql postgres -h "$SERVERNAME" -p "$PORT" -c "grant all on database $DBNAME to $DBUSERNAME;"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit "$retvalue"
fi

gunzip -c "$DUMPFILENAME" | /usr/pgsql-"$PGSQLVERSION"/bin/pg_restore -U "$DBUSERNAME" -h "$SERVERNAME" -p "$PORT" --clean --no-privileges --no-owner -d "$DBNAME"
retvalue=$?

exit "$retvalue"

