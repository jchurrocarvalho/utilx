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
    echo "set recursive acl user and perms applying only to dirs (several paths)"
    echo "if user/group is EMPTY or 0, the acl is set for no named user/group"
    echo "Usage: setacl-u-r-dirsonly.sh <recalculate mask? (0/1)> <user> <perms> <path> ..."
}

if [ "$4" = "" ]; then
    usage
    exit 1
fi

if [ "$1" = "1" ]; then
    RECALCULATEMASKOPTION=""
else
    RECALCULATEMASKOPTION="-n"
fi

#
if [ "$2" = "EMPTY" ] || [ "$2" = "0" ]; then
    USERID=""
else
    USERID="$2"
fi

PERMS="$3"

i=0

for arg in "$@"; do
    if [ $i -ge 3 ]; then
        echo "=> Path: $arg"

        find -P "$arg" -type d -exec setfacl "$RECALCULATEMASKOPTION" -m u:"$USERID":"$PERMS" '{}' \;
    fi
    i=$((i+1))
done

exit 0

