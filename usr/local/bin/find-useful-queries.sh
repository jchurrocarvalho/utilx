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

SCRIPTTITLE="find-useful-queries"

usage()
{
    echo "several find useful queries"
    echo "Queries like strange perms such as group write but user without write perm ... and so on ..."
    echo "Usage: $SCRIPTTITLE.sh <include read bit in others perms? (0/1)> <path> ..."
}

if [ "$2" = "" ]; then
    usage
    exit 2
fi

# git in .git directory internal structure objects directory (.git/objects) make files with only r perms

if [ "$1" = "1" ]; then
    INCLUDEREADOTHERS="1"
else
    INCLUDEREADOTHERS="0"
fi

i=0

for arg in "$@"; do
    if [ $i -ge 1 ]; then
        echo ">> Path: $arg"

        echo ">>>> Find files in .git dir with g w and ! u w ..."
        find -P "$arg" -type f -ipath "*/.git/*" -perm /g=w ! -perm /u=w -print

        echo ">>>> Find files in .git dir with g x and ! u x ..."
        find -P "$arg" -type f -ipath "*/.git/*" -perm /g=x ! -perm /u=x -print

        echo ">>>> Find files in .svn dir with g w and ! u w ..."
        find -P "$arg" -type f -ipath "*/.svn/*" -perm /g=w ! -perm /u=w -print

        echo ">>>> Find files in .svn dir with g x and ! u x ..."
        find -P "$arg" -type f -ipath "*/.svn/*" -perm /g=x ! -perm /u=x -print

        echo ">>>> Find files excluding .git and .svn dir with g x and ! u x ..."
        find -P "$arg" -type f ! -ipath "*/.git/*" ! -ipath "*/.svn/*" -perm /g=x ! -perm /u=x -print

        echo ">>>> Find dirs excluding .git and .svn dir with g x and ! u x ..."
        find -P "$arg" -type d ! -ipath "*/.git/*" ! -ipath "*/.svn/*" -perm /g=x ! -perm /u=x -print

        echo ">>>> Find files excluding .git and .svn dir with g w and ! u w ..."
        find -P "$arg" -type f ! -ipath "*/.git/*" ! -ipath "*/.svn/*" -perm /g=w ! -perm /u=w -print

        echo ">>>> Find dirs excluding .git and .svn dir with g w and ! u w ..."
        find -P "$arg" -type d ! -ipath "*/.git/*" ! -ipath "*/.svn/*" -perm /g=w ! -perm /u=w -print

        echo ">>>> Find dirs with g w and ! u w ..."
        find -P "$arg" -type d -perm /g=w ! -perm /u=w -print

        echo ">>>> Find files or dirs with group s bit set ..."
        find -P "$arg" -perm /g=s -print

        if [ "$INCLUDEREADOTHERS" = "1" ]; then
            echo ">>>> Find any excluding symlinks with any bit set in others! ..."
            find -P "$arg" ! -type l -perm /o=rwx -print
        else
            echo ">>>> Find any excluding symlinks with w or x bit set in others! ..."
            find -P "$arg" ! -type l -perm /o=wx -print
        fi
    fi
    i=$((i+1))
done

exit 0

