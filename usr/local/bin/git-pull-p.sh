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
    echo "git pull with path"
    echo "Usage: git-pull-p.sh <path> <git pull options (optional)>"
}

if [ "$1" = "" ]; then
    usage
    exit 2
fi

# redirect stdin and stderr for PATHFILETITLE.txt
#exec 1>&1
#exec 2>&1

GIT_REPO_PATH="$1"

#

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

workdir=$(eval 'pwd')

echo "-> git pull in $GIT_REPO_PATH with options = [$git_pull_options]"

cd "$GIT_REPO_PATH" || exit 1
if [ "$git_pull_options" != "" ]; then
    git pull $git_pull_options
else
    git pull
fi

cd "$workdir" || exit 1

exit 0

