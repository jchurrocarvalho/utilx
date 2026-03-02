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
    echo "Import pfx to java keystore"
    echo "Store type available values are: jceks, jks, dks, pkcs11, pkcs12 (default)"
    echo "If destination alias is specified also source alias must be specified"
    echo "Usage: cert-java-keystore-import-from-pfx.sh <keystore filename> <store type> <pfx filename> <dest keypass> <dest alias (optional)> <src alias (optional)>"
}

KEYSTOREFILENAME="$1"
STORETYPE="$2"
PFXFILENAME="$3"
DESTKEYPASS="$4"
DESTALIAS="$5"
SRCALIAS="$6"

if [ "$KEYSTOREFILENAME" = "" ] || [ "$STORETYPE" = "" ] || [ "$PFXFILENAME" = "" ] || [ "$DESTKEYPASS" = "" ]; then
    usage
    exit 2
fi

if [ "$DESTALIAS" = "" ]; then
    keytool -importkeystore -srckeystore "$PFXFILENAME" -srcstoretype pkcs12 -destkeystore "$KEYSTOREFILENAME" -deststoretype "$STORETYPE" -destkeypass "$DESTKEYPASS"
elif [ "$SRCALIAS" = "" ]; then
    keytool -importkeystore -srckeystore "$PFXFILENAME" -srcstoretype pkcs12 -destkeystore "$KEYSTOREFILENAME" -deststoretype "$STORETYPE" -destkeypass "$DESTKEYPASS" -destalias "$DESTALIAS"
else
    keytool -importkeystore -srckeystore "$PFXFILENAME" -srcstoretype pkcs12 -destkeystore "$KEYSTOREFILENAME" -deststoretype "$STORETYPE" -destkeypass "$DESTKEYPASS" -destalias "$DESTALIAS" -srcalias "$SRCALIAS"
fi
retvalue=$?

exit "$retvalue"

