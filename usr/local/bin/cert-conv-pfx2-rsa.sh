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
    echo "cert/key convert/extract from pfx 2 several outputs (use rsa for key)"
    echo "Usage: cert-conv-pfx2-rsa.sh <pfx filename> <prefix file title (filename without extension)>"
}

if [ "$2" = "" ]; then
    usage
    exit 2
fi

PKEY_ENC_PEM_FILENAME="$2"-pkey.pem
PKEY_ENC_KEY_FILENAME="$2"-pkey.key
PKEY_NOE_PEM_FILENAME="$2"-pkey-noe.pem
PKEY_RSA_KEY_FILENAME="$2"-rsa.key
CERT_CLIENT_CERT_FILENAME="$2".crt
CERT_ALL_CERTS_FILENAME="$2"-certs.crt
CERT_CACERTS_FILENAME="$2"-cacerts.crt
CERT_CACERTS_CHAIN_FILENAME="$2"-cacerts-chain.crt
CERT_CACERTS_CHAIN_WITHOUTBAGATTRIBUTES_FILENAME="$2"-cacerts-chain-withoutbagattributes.crt
CERT_ENC_PKEY_CERT_PEM_FILENAME="$2"-pkey-cert.pem
CERT_NOE_PKEY_CERT_PEM_FILENAME="$2"-pkey-cert-noe.pem
CERT_ENC_PKEY_ALL_CERTS_PEM_FILENAME="$2"-pkey-certs.pem
CERT_NOE_PKEY_ALL_CERTS_PEM_FILENAME="$2"-pkey-certs-noe.pem
CERT_ENC_PKEY_ALL_CERTS_DER_FILENAME="$2"-pkey-certs.der
CERT_RSA_KEY_PEM_FILENAME="$2"-rsa-pkey.pem

echo "Exporting only encrypted private key to $PKEY_ENC_PEM_FILENAME in pem format"
openssl pkcs12 -in "$1" -nocerts -out "$PKEY_ENC_PEM_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$PKEY_ENC_PEM_FILENAME"

echo "Exporting only encrypted private key to $PKEY_ENC_KEY_FILENAME in pem format"
openssl pkcs12 -in "$1" -nocerts -out "$PKEY_ENC_KEY_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$PKEY_ENC_KEY_FILENAME"

echo "Exporting rsa key to $CERT_RSA_KEY_PEM_FILENAME in pem format"
openssl rsa -in "$PKEY_ENC_KEY_FILENAME" -out "$CERT_RSA_KEY_PEM_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_RSA_KEY_PEM_FILENAME"

echo "Exporting no encrypted private key to $PKEY_NOE_PEM_FILENAME in pem format"
openssl pkcs12 -in "$1" -nocerts -out "$PKEY_NOE_PEM_FILENAME" -noenc
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$PKEY_NOE_PEM_FILENAME"

echo "Exporting rsa key filename without passphrase to $PKEY_RSA_KEY_FILENAME"
openssl rsa -in "$PKEY_NOE_PEM_FILENAME" -out "$PKEY_RSA_KEY_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$PKEY_RSA_KEY_FILENAME"

echo "Exporting client certificate $CERT_CLIENT_CERT_FILENAME"
openssl pkcs12 -in "$1" -clcerts -nokeys -out "$CERT_CLIENT_CERT_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_CLIENT_CERT_FILENAME"

echo "Exporting all certificates $CERT_ALL_CERTS_FILENAME"
openssl pkcs12 -in "$1" -nokeys -out "$CERT_ALL_CERTS_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_ALL_CERTS_FILENAME"

echo "Exporting CA certificates $CERT_CACERTS_FILENAME"
openssl pkcs12 -in "$1" -cacerts -nokeys -out "$CERT_CACERTS_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_CACERTS_FILENAME"

echo "Exporting CA certificates with chain $CERT_CACERTS_CHAIN_FILENAME"
openssl pkcs12 -in "$1" -cacerts -nokeys -out "$CERT_CACERTS_CHAIN_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_CACERTS_CHAIN_FILENAME"

echo "Exporting CA certificates with chain without bag attributes $CERT_CACERTS_CHAIN_WITHOUTBAGATTRIBUTES_FILENAME"
openssl pkcs12 -in "$1" -cacerts -nokeys | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "$CERT_CACERTS_CHAIN_WITHOUTBAGATTRIBUTES_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_CACERTS_CHAIN_WITHOUTBAGATTRIBUTES_FILENAME"

echo "Exporting encrypted private key and cert combined to $CERT_ENC_PKEY_CERT_PEM_FILENAME in pem format"
openssl pkcs12 -in "$1" -out "$CERT_ENC_PKEY_CERT_PEM_FILENAME" -clcerts
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_ENC_PKEY_CERT_PEM_FILENAME"

echo "Exporting no encrypted private key and cert combined to $CERT_NOE_PKEY_CERT_PEM_FILENAME in pem format"
openssl pkcs12 -in "$1" -out "$CERT_NOE_PKEY_CERT_PEM_FILENAME" -clcerts -noenc
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_NOE_PKEY_CERT_PEM_FILENAME"

echo "Exporting encrypted private key and all certs combined to $CERT_ENC_PKEY_ALL_CERTS_PEM_FILENAME in pem format"
openssl pkcs12 -in "$1" -out "$CERT_ENC_PKEY_ALL_CERTS_PEM_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_ENC_PKEY_ALL_CERTS_PEM_FILENAME"

echo "Exporting no encrypted private key and all certs combined to $CERT_NOE_PKEY_ALL_CERTS_PEM_FILENAME in pem format"
openssl pkcs12 -in "$1" -out "$CERT_NOE_PKEY_ALL_CERTS_PEM_FILENAME" -noenc
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_NOE_PKEY_ALL_CERTS_PEM_FILENAME"

echo "Exporting pem with encrypted key and all certs to der to use for example to import to java keystore, $CERT_ENC_PKEY_ALL_CERTS_DER_FILENAME"
openssl x509 -in "$CERT_ENC_PKEY_ALL_CERTS_PEM_FILENAME" -outform DER -out "$CERT_ENC_PKEY_ALL_CERTS_DER_FILENAME"
retvalue=$?
if [ "$retvalue" != "0" ]; then
    echo "An error was returned. {Line: $LINENO, Error Code: $retvalue}"
    exit $retvalue
fi
chmod go-rwx "$CERT_ENC_PKEY_ALL_CERTS_DER_FILENAME"
retvalue=$?

exit $retvalue

