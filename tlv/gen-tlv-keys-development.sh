#!/bin/sh

set -e

openssl genpkey -algorithm RSA \
	-pkeyopt rsa_keygen_bits:4096 \
	-out tlv-4096-development.key \
	-outpubkey tlv-4096-development.pem

openssl genpkey -algorithm EC \
	-pkeyopt ec_paramgen_curve:prime256v1 \
	-out tlv-ecdsa-development.key \
	-outpubkey tlv-ecdsa-development.pem
