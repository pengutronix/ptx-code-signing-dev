#!/bin/bash

set -euo pipefail

# Give the certificates an expiry date 1000 Years in the future.
VALIDITY_DAYS="365000"

KEY_TYPE="rsa:4096"

# PK

echo "Generate Platform Key"

openssl req -new -x509 -nodes -sha256 \
    -newkey "${KEY_TYPE}" -subj "/CN=PK/" -days "${VALIDITY_DAYS}" \
    -keyout PK.key.pem -out PK.cert.pem

# KEK

echo "Generate and sign Key Exchange Key"

openssl req -new -sha256 -nodes \
    -newkey "${KEY_TYPE}" -subj "/CN=KEK/" \
    -keyout KEK.key.pem -out KEK.csr

openssl x509 -req -in KEK.csr -CA PK.cert.pem -CAkey PK.key.pem \
    -CAcreateserial -days "${VALIDITY_DAYS}" -sha256 \
    -out KEK.cert.pem

# db

echo "Generate and sign Database Key"

openssl req -new -sha256 -nodes \
    -newkey "${KEY_TYPE}" -subj "/CN=DB/" \
    -keyout db.key.pem -out db.csr

openssl x509 -req -in db.csr -CA KEK.cert.pem -CAkey KEK.key.pem \
    -CAcreateserial -days "${VALIDITY_DAYS}" -sha256 \
    -out db.cert.pem

# cleanup

echo "Remove certificate signing requests"

rm *.csr
