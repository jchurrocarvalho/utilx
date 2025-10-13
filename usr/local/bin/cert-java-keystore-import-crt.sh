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
    echo "Import cert to java keystore"
    echo "Store type available values are: jceks, jks, dks, pkcs11, pkcs12 (default)"
    echo "Usage: cert-java-keystore-import-cert.sh <alias> <keystore filename> <store type> <cert filename>"
}

ALIAS="$1"
KEYSTOREFILENAME="$2"
STORETYPE="$3"
CERTFILENAME="$4"

if [ "$ALIAS" = "" ] || [ "$KEYSTOREFILENAME" = "" ] || [ "$STORETYPE" = "" ] || [ "$CERTFILENAME" = "" ]; then
    usage
    exit 2
fi

keytool -importcert -alias "$ALIAS" -keystore "$KEYSTOREFILENAME" -storetype "$STORETYPE" -file "$CERTFILENAME"
retvalue=$?

exit $retvalue

