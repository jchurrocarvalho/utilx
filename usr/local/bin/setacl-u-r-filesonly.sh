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
    echo "set recursive acl user and perms applying only to files (several paths)"
    echo "if user/group is EMPTY or 0, the acl is set for no named user/group"
    echo "Usage: setacl-u-r-filesonly.sh <recalculate mask? (0/1)> <user> <perms> <include x bit if owner user has x bit ()0/1)> <path> ..."
}

if [ "$5" = "" ]; then
    usage
    exit 1
fi

if [ "$1" = "1" ]; then
    RECALCULATEMASKOPTION=""
else
    RECALCULATEMASKOPTION="-n"
fi

if [[ "$3" == *x* ]]; then
    echo "perms includes execute bit (x), which I refuse to apply to all files in a path"
    exit 2
fi

if [ "$4" = "1" ]; then
    XBIT="1"
else
    XBIT="0"
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
    if [ $i -ge 4 ]; then
        echo "=> Path: $arg"

        if [ "$XBIT" = "1" ]; then
            #find -P "$arg" -type f -perm /u=x -exec setfacl "$RECALCULATEMASKOPTION" -m u:"$USERID":"$PERMS"x '{}' \;
            #find -P "$arg" -type f ! -perm /u=x -exec setfacl "$RECALCULATEMASKOPTION" -m u:"$USERID":"$PERMS" '{}' \;

            find -P "$arg" \
                \( -type f -perm /u=x -exec setfacl "$RECALCULATEMASKOPTION" -m u:"$USERID":"$PERMS"x '{}' \; \) , \
                \( -type f ! -perm /u=x -exec setfacl "$RECALCULATEMASKOPTION" -m u:"$USERID":"$PERMS" '{}' \; \)
        else
            find -P "$arg" -type f -exec setfacl "$RECALCULATEMASKOPTION" -m u:"$USERID":"$PERMS" '{}' \;
        fi
    fi
    i=$((i+1))
done

exit 0

