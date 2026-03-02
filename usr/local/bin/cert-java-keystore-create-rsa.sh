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
    echo "Create java keystore in specified format (PKCS12 is default) (use rsa for key)"
    echo "Store type available values are: jceks, jks, dks, pkcs11, pkcs12 (default)"
    echo "dname example:"
    echo "    -dname \"CN=[Common Name], OU=[organisationunit], O=[organisation], L=[town/city], ST=[state/province], C=[GB]\""
    echo "Usage: cert-java-keystore-create-rsa.sh <alias> <keystore path> <keystore name (filename without path)> <validity> <keysize> <store type (optional)> <dname (optional)>"
}

#
# dname example
# -dname "CN=[Common Name], OU=[organisationunit], O=[organisation], L=[town/city], ST=[state/province], C=[GB]"
#

ALIAS="$1"
KEYSTOREPATH="$2"
KEYSTOREFILENAME="$3"
KEYSTOREPATHFILENAME="$KEYSTOREPATH"/"$KEYSTOREFILENAME"
VALIDITY="$4"
KEYSIZE="$5"

if [ "$6" = "" ]; then
    STORETYPE="PKCS12"
else
    STORETYPE="$6"
fi

if [ "$7" = "" ]; then
    DNAME=""
else
    DNAME="$7"
fi

if [ "$ALIAS" = "" ] || [ "$KEYSTOREPATH" = "" ] || [ "$KEYSTOREFILENAME" = "" ] || [ "$VALIDITY" = "" ] || [ "$KEYSIZE" = "" ]; then
    usage
    exit 2
fi

mkdir -p "$KEYSTOREPATH"

if [ "$DNAME" = "" ]; then
    keytool -genkey -alias "$ALIAS" -keyalg RSA -keystore "$KEYSTOREPATHFILENAME" -validity "$VALIDITY" -keysize "$KEYSIZE" -storetype "$STORETYPE"
else
    keytool -genkey -alias "$ALIAS" -keyalg RSA -keystore "$KEYSTOREPATHFILENAME" -validity "$VALIDITY" -keysize "$KEYSIZE" -storetype "$STORETYPE" -dname "$DNAME"
fi
retvalue=$?

exit "$retvalue"

