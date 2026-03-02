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
    echo "Import cert and key to java keystore"
    echo "Store type available values are: jceks, jks, dks, pkcs11, pkcs12 (default)"
    #echo "Usage: cert-java-keystore-import-crt-key.sh <keystore filename> <store type> <certificate filename> <key filename> <dest keypass> <alias>"
    echo "Usage: cert-java-keystore-import-crt-key.sh <keystore filename> <store type> <certificate filename> <key filename> <alias>"
}

#DTIMENOW=$(date +%Y%m%d%H%M%S)

KEYSTOREFILENAME="$1"
STORETYPE="$2"
CERTFILENAME="$3"
KEYFILENAME="$4"

#DESTKEYPASS="$5"
#ALIAS="$6"
ALIAS="$5"
TMPPFXFILENAME="$ALIAS"-tmp-pfx.pfx

#if [ "$KEYSTOREFILENAME" = "" ] || [ "$STORETYPE" = "" ] || [ "$CERTFILENAME" = "" ] || [ "$KEYFILENAME" = "" ] || [ "$DESTKEYPASS" = "" ] || [ "$ALIAS" = "" ]; then
if [ "$KEYSTOREFILENAME" = "" ] || [ "$STORETYPE" = "" ] || [ "$CERTFILENAME" = "" ] || [ "$KEYFILENAME" = "" ] || [ "$ALIAS" = "" ]; then
    usage
    exit 2
fi

cert-create-pfx-from-crt-key.sh "$CERTFILENAME" "$KEYFILENAME" "$TMPPFXFILENAME" "$ALIAS"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit "$retvalue"
fi

#cert-java-keystore-import-pfx.sh "$KEYSTOREFILENAME" "$STORETYPE" "$TMPPFXFILENAME" "$DESTKEYPASS" "$ALIAS" "$ALIAS"
cert-java-keystore-import-pfx2.sh "$KEYSTOREFILENAME" "$STORETYPE" "$TMPPFXFILENAME" "$ALIAS" "$ALIAS"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit "$retvalue"
fi

rm -f "$TMPPFXFILENAME"
retvalue=$?

exit "$retvalue"

