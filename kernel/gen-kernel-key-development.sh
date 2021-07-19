#!/bin/sh

set -e

openssl genrsa -f4 -out kernel-development.key 4096
openssl req -batch -new -days 36500 -x509 -config gen-kernel-key-development.conf \
	-key kernel-development.key -out kernel-development.crt

