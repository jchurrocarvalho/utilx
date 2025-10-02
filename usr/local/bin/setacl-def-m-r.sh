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
    echo "set recursive default acl mask according to base group perms (several paths)"
	echo "Usage: setacl-def-m-r.sh <path> ..."
}

if [ "$1" = "" ]; then
    usage
    exit 1
fi

#

i=0

for arg in "$@"; do
    echo "=> Path: $arg"

    #find -P "$arg" -type d -perm -g=rwx -exec setfacl -dm m::rwX '{}' \;
    #find -P "$arg" -type d -perm -g=rx ! -perm /g=w -exec setfacl -dm m::rX '{}' \;
    #find -P "$arg" -type d ! -perm /g=r ! -perm /g=w ! -perm /g=x -exec setfacl -dm m::000 '{}' \;

    find -P "$arg" \
        \( -type d -perm -g=rwx -exec setfacl -dm m::rwX '{}' \; \) , \
        \( -type d -perm -g=rx ! -perm /g=w -exec setfacl -dm m::rX '{}' \; \) , \
        \( -type d ! -perm /g=r ! -perm /g=w ! -perm /g=x -exec setfacl -dm m::000 '{}' \; \)
    i=$((i+1))
done

exit 0

