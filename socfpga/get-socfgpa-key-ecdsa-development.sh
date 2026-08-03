#!/bin/sh

set -e

# Generate the root key
openssl genpkey -algorithm EC \
	-pkeyopt ec_paramgen_curve:secp384r1 \
	-out agilex5-root-ecdsa-development.pem \
	-outpubkey agilex5-root-ecdsa-development.pub.pem

# Generate the root certificate
quartus_sign \
	--family=agilex5 --operation=make_root \
	agilex5-root-ecdsa-development.pub.pem \
	agilex5-root-ecdsa-development.qky

# Output root key certificate hash to be burned into fuses
quartus_sign \
	--family=agilex5 --operation=fuse_info \
	agilex5-root-ecdsa-development.qky \
	agilex5-root-ecdsa-development.txt

# Generate the signing key
openssl genpkey -algorithm EC \
	-pkeyopt ec_paramgen_curve:secp384r1 \
	-out agilex5-ecdsa-development.pem \
	-outpubkey agilex5-ecdsa-development.pub.pem

# Use the key for signing FPGA configuration, HPS software, and HPS debug enable
# SIGN_CORE = 0x2
# SIGN_HPS = 0x4
# SIGN_DEBUG_ENABLE = 0x8
PERMISSION=0xe

# Revoke the key with a key cancellation certificate for ID 1
CANCEL_ID=1

# Convert PEM to traditional format, because append_key does not accept PKCS#8 format.
openssl ec -in agilex5-root-ecdsa-development.pem -out agilex5-root-ecdsa-development-sec1.pem

# Generate certificate chain for signing key and sign it with the root key
quartus_sign \
	--family=agilex5 --operation=append_key \
	--previous_pem=agilex5-root-ecdsa-development-sec1.pem \
	--previous_qky=agilex5-root-ecdsa-development.qky \
	--permission="${PERMISSION}" --cancel="${CANCEL_ID}" \
	--input_pem=agilex5-ecdsa-development.pub.pem \
	agilex5-ecdsa-development.qky
