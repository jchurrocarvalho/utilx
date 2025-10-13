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

# pfx = pkcs12

usage()
{
    echo "Create keystore and import certificate and key (use rsa for key)"
    echo "Keystore filename is the hostname fqdn concatenated with .keystore extension"
    echo "Store type is pkcs12 (default)"
    echo "dname example:"
    echo "    -dname \"CN=[Common Name], OU=[organisationunit], O=[organisation], L=[town/city], ST=[state/province], C=[GB]\""
    #echo "Usage: cert-java-keystore-create-import-crt-key.sh <keystore path> <certificate filename> <key filename> <dest keypass> <dname (optional)>"
    echo "Usage: cert-java-keystore-create-import-crt-key-rsa.sh <keystore path> <certificate filename> <key filename> <keysize (2048/4096)> <dname (optional)>"
}

#
# dname example
# -dname "CN=[Common Name], OU=[organisationunit], O=[organisation], L=[town/city], ST=[state/province], C=[GB]"
#

DTIMENOW=$(date +%Y%m%d%H%M%S)
HOSTNAME=$(hostname --long)

ALIAS="$HOSTNAME"
KEYSTOREPATH="$1"
KEYSTOREFILENAME="$HOSTNAME".keystore
KEYSTOREPATHFILENAME="$KEYSTOREPATH"/"$KEYSTOREFILENAME"
CERTFILENAME="$2"
KEYFILENAME="$3"
#DESTKEYPASS="$4"
KEYSIZE="$4"

if [ "$5" = "" ]; then
    DNAME=""
else
    DNAME="$5"
fi

TMPPFXFILENAME="/tmp/$DTIMENOW.pfx.tmp"

#if [ "$KEYSTOREPATH" = "" ] || [ "$CERTFILENAME" = "" ] || [ "$KEYFILENAME" = "" ] || [ "$DESTKEYPASS" = "" ]; then
if [ "$KEYSTOREPATH" = "" ] || [ "$CERTFILENAME" = "" ] || [ "$KEYFILENAME" = "" ]; then
    usage
    exit 2
fi

rm -i "$KEYSTOREPATHFILENAME"

if [ "$DNAME" = "" ]; then
    cert-java-keystore-create-rsa.sh root "$KEYSTOREPATH" "$KEYSTOREFILENAME" 3650 "$KEYSIZE" pkcs12
else
    cert-java-keystore-create-rsa.sh root "$KEYSTOREPATH" "$KEYSTOREFILENAME" 3650 "$KEYSIZE" pkcs12 "$DNAME"
fi
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi

cert-create-pfx-from-crt-key.sh "$CERTFILENAME" "$KEYFILENAME" "$TMPPFXFILENAME" "$ALIAS"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi

#cert-java-keystore-import-pfx.sh "$KEYSTOREPATHFILENAME" pkcs12 "$TMPPFXFILENAME" "$DESTKEYPASS" "$ALIAS" "$ALIAS"
cert-java-keystore-import-pfx2.sh "$KEYSTOREPATHFILENAME" pkcs12 "$TMPPFXFILENAME" "$ALIAS" "$ALIAS"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi

rm -f "$TMPPFXFILENAME"
retvalue=$?

exit $retvalue

