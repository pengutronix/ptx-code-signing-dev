#!/bin/sh

set -e

openssl genrsa -f4 -out fit-4096-development.key 4096
openssl req -batch -new -days 36500 -x509 -config gen-fit-key-4096-development.conf \
	-key fit-4096-development.key -out fit-4096-development.crt
openssl pkcs12 -export -inkey fit-4096-development.key -in fit-4096-development.crt \
	-out fit-4096-development.p12

