#!/bin/sh

set -e


# The key was generated using these commands:
#openssl ecparam -name prime256v1 -genkey -noout -out fit-ecdsa-development.key
#openssl req -batch -new -days 36500 -x509 -config gen-fit-key-ecdsa-development.conf \
#        -key fit-ecdsa-development.key -out fit-ecdsa-development.crt
#openssl pkcs12 -export -inkey fit-ecdsa-development.key -in fit-ecdsa-development.crt \
#        -out fit-ecdsa-development.p12
#openssl x509 -in fit-ecdsa-development.crt -noout -pubkey -out fit-ecdsa-development.pub

# As FIT doesn't use certificates, generating a key pair would be enough as well:
openssl genpkey -algorithm EC \
        -pkeyopt ec_paramgen_curve:prime256v1 \
        -out fit-ecdsa-development.key \
        -outpubkey fit-ecdsa-development.pub
