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
    echo "Cert create self-signed without request (use rsa for key)"
    echo "Usage: cert-create-crt-self-rsa.sh <certificate file title> <validity> <keysize (2048/4096)>"
}

if [ "$3" = "" ]; then
    usage
    exit 1
fi

KEYFILENAME="$1"-self-rsa.key
CERTFILENAME="$1"-self.crt
KEYSIZE="$3"

if [ "$2" = "0" ]; then
    VALIDITY="365"
else
    VALIDITY="$2"
fi

echo "Generating self-signed key and crt. $KEYFILENAME, $CERTFILENAME"
openssl req -x509 -noenc -days "$VALIDITY" -newkey rsa:"$KEYSIZE" -keyout "$KEYFILENAME" -out "$CERTFILENAME"

