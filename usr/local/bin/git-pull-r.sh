#!/bin/bash

#
# Released under MIT License
# Copyright (c) 2018-2026 Jose Manuel Churro Carvalho
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
    echo "git pull recursive"
    echo "Usage: git-pull-r.sh <bypass test for .git-operation-ignore [0|1]> <git pull options (optional)>"
}

if [ -z "${1:-}" ]; then
    usage
    exit 2
fi

BYPASS_TEST_OPERATION_IGNORE="$1"

git_pull_options=""
i=0

for arg in "$@"; do
    if [ $i -ge 1 ]; then
        if [ "$git_pull_options" != "" ]; then
            git_pull_options+=" "
        fi
        git_pull_options+="$arg"
    fi
    i=$((i+1))
done

#find -mindepth 1 -maxdepth 1 -type d \( -exec test -d '{}/.git' \; \) -exec git-pull-p.sh '{}' \;
if [ "$git_pull_options" != "" ]; then
    find . -type d \( -exec test -d '{}/.git' \; \) -exec git-pull-p.sh "$BYPASS_TEST_OPERATION_IGNORE" '{}' $git_pull_options \;
else
    find . -type d \( -exec test -d '{}/.git' \; \) -exec git-pull-p.sh "$BYPASS_TEST_OPERATION_IGNORE" '{}' \;
fi
retvalue=$?

exit "$retvalue"

