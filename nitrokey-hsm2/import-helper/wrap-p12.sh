#!/bin/sh

set -e

key="$1"
base="${key##*/}"
base="${base%.*}"

openssl req -batch -new -days 36500 -x509 -config cert.conf \
        -key "$key" -out "./$base.crt"

openssl pkcs12 -export -inkey "$key" -in "$base.crt" \
        -passout pass:test -out "./$base.p12"
