#!/bin/sh

set -e

openssl req -batch -new -days 36500 -x509 -config cert.conf \
        -key ../tlv-4096-development.key -out tlv-4096-development.crt
openssl pkcs12 -export -inkey tlv-4096-development.key -in tlv-4096-development.crt \
        -passout pass:test -out tlv-4096-development.p12

openssl req -batch -new -days 36500 -x509 -config cert.conf \
        -key ../tlv-ecdsa-development.key -out tlv-ecdsa-development.crt
openssl pkcs12 -export -inkey tlv-ecdsa-development.key -in tlv-ecdsa-development.crt \
        -passout pass:test -out tlv-ecdsa-development.p12
