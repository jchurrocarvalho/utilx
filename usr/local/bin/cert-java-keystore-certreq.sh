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
    echo "Create certificate request for alias"
    echo "Store type available values are: jceks, jks, dks, pkcs11, pkcs12 (default)"
    echo "Usage: cert-java-keystore-certreq.sh <alias> <keystore filename> <store type> <cert request filename>"
}

ALIAS="$1"
KEYSTOREPATHFILENAME="$2"
STORETYPE="$3"
CERTREQFILENAME="$4"

if [ "$ALIAS" = "" ] || [ "$KEYSTOREPATHFILENAME" = "" ] || [ "$STORETYPE" = "" ] || [ "$CERTREQFILENAME" = "" ]; then
    usage
    exit 2
fi

keytool -certreq -alias "$ALIAS" -keystore "$KEYSTOREPATHFILENAME" -storetype "$STORETYPE" -file "$CERTREQFILENAME"
retvalue=$?

exit "$retvalue"

