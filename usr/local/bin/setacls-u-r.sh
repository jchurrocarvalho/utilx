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
    echo "set recursive acl user according to owner user perms (several users)"
    echo "if user/group is EMPTY or 0, the acl is set for no named user/group"
    echo "Usage: setacls-u-r.sh <recalculate mask? (0/1)> <path> <user> ..."
}

if [ "$3" = "" ]; then
    usage
    exit 1
fi

if [ "$1" = "1" ]; then
    RECALCULATEMASKOPTION=""
else
    RECALCULATEMASKOPTION="-n"
fi

BASEPATH="$2"

#
acl_args1=""
i=0

for arg in "$@"; do
    if [ $i -ge 2 ]; then
        if [ "$acl_args1" != "" ]; then
            acl_args1+=","
        fi
        if [ "$arg" = "EMPTY" ] || [ "$arg" = "0" ]; then
            USERID=""
        else
            USERID="$arg"
        fi
        acl_args1+="u:$USERID:rwx"
    fi
    i=$((i+1))
done

#find -P "$BASEPATH" ! -type l -perm -u=rwx -exec setfacl "$RECALCULATEMASKOPTION" -m "$acl_args1" '{}' \;

#
acl_args2=""
i=0

for arg in "$@"; do
    if [ $i -ge 2 ]; then
        if [ "$acl_args2" != "" ]; then
            acl_args2+=","
        fi
        if [ "$arg" = "EMPTY" ] || [ "$arg" = "0" ]; then
            USERID=""
        else
            USERID="$arg"
        fi
        acl_args2+="u:$USERID:rx"
    fi
    i=$((i+1))
done

#find -P "$BASEPATH" ! -type l -perm -u=rx ! -perm /u=w -exec setfacl "$RECALCULATEMASKOPTION" -m "$acl_args2" '{}' \;

#
acl_args3=""
i=0

for arg in "$@"; do
    if [ $i -ge 2 ]; then
        if [ "$acl_args3" != "" ]; then
            acl_args3+=","
        fi
        if [ "$arg" = "EMPTY" ] || [ "$arg" = "0" ]; then
            USERID=""
        else
            USERID="$arg"
        fi
        acl_args3+="u:$USERID:rw"
    fi
    i=$((i+1))
done

#find -P "$BASEPATH" -type f -perm -u=rw ! -perm /u=x -exec setfacl "$RECALCULATEMASKOPTION" -m "$acl_args3" '{}' \;

#
acl_args4=""
i=0

for arg in "$@"; do
    if [ $i -ge 2 ]; then
        if [ "$acl_args4" != "" ]; then
            acl_args4+=","
        fi
        if [ "$arg" = "EMPTY" ] || [ "$arg" = "0" ]; then
            USERID=""
        else
            USERID="$arg"
        fi
        acl_args4+="u:$USERID:r"
    fi
    i=$((i+1))
done

#find -P "$BASEPATH" -type f -perm -u=r ! -perm /u=w ! -perm /u=x -exec setfacl "$RECALCULATEMASKOPTION" -m "$acl_args4" '{}' \;

find -P "$BASEPATH" \
    \( ! -type l -perm -u=rwx -exec setfacl "$RECALCULATEMASKOPTION" -m "$acl_args1" '{}' \; \) , \
    \( ! -type l -perm -u=rx ! -perm /u=w -exec setfacl "$RECALCULATEMASKOPTION" -m "$acl_args2" '{}' \; \) , \
    \( -type f -perm -u=rw ! -perm /u=x -exec setfacl "$RECALCULATEMASKOPTION" -m "$acl_args3" '{}' \; \) , \
    \( -type f -perm -u=r ! -perm /u=w ! -perm /u=x -exec setfacl "$RECALCULATEMASKOPTION" -m "$acl_args4" '{}' \; \)

exit 0

