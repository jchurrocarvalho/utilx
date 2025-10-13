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

# p7b/p7c = pkcs7

usage()
{
    echo "cert/key convert from p7b and extract chain and certs"
    echo "Usage: cert-conv-p7b2-chain.sh <p7b filename> <filetitle (filename without extension)>"
}

if [ "$2" = "" ]; then
    usage
    exit 2
fi

PKEY_PEM_FILENAME="$2"-pkey.pem
CERT_ALL_CERTS_PEM_FILENAME="$2"-certs.pem
CERT_ALL_CERTS_DER_FILENAME="$2"-certs.der
CERT_X509_DER_FILENAME="$2"-x509.der

echo "Exporting private key to $PKEY_PEM_FILENAME in pem format"
openssl pkey -in "$1" -out "$PKEY_PEM_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi

echo "Exporting all certificates to $CERT_ALL_CERTS_PEM_FILENAME in pem format"
openssl pkcs7 -print_certs -in "$1" -out "$CERT_ALL_CERTS_PEM_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi

echo "Exporting all certificates to $CERT_ALL_CERTS_DER_FILENAME in der format"
openssl pkcs7 -print_certs -in "$1" -outform DER -out "$CERT_ALL_CERTS_DER_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi

echo "Exporting x509 in DER format to $CERT_X509_DER_FILENAME"
openssl x509 -in "$1" -outform DER -out "$CERT_X509_DER_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
retvalue=$?

exit $retvalue

