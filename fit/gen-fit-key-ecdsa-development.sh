#!/bin/sh

set -e

openssl ecparam -name prime256v1 -genkey -noout -out fit-ecdsa-development.key

openssl req -batch -new -days 36500 -x509 -config gen-fit-key-ecdsa-development.conf \
	-key fit-ecdsa-development.key -out fit-ecdsa-development.crt

openssl pkcs12 -export -inkey fit-ecdsa-development.key -in fit-ecdsa-development.crt \
	-out fit-ecdsa-development.p12
