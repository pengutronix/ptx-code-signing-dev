#!/bin/sh

set -e

# The key was generated using these commands:
#openssl genrsa -f4 -out fit-4096-development.key 4096
#openssl req -batch -new -days 36500 -x509 -config gen-fit-key-4096-development.conf \
#        -key fit-4096-development.key -out fit-4096-development.crt
#openssl pkcs12 -export -inkey fit-4096-development.key -in fit-4096-development.crt \
#        -out fit-4096-development.p12
#openssl x509 -in fit-4096-development.crt -noout -pubkey -out fit-4096-development.pub

# As FIT doesn't use certificates, generating a key pair would be enough as well:
openssl genpkey -algorithm RSA \
        -pkeyopt rsa_keygen_bits:4096 \
        -out fit-4096-development.key \
        -outpubkey fit-4096-development.pub
