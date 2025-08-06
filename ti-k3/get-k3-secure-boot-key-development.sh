#!/bin/bash
#
# TI K3 images are signed with a 4096 bit RSA keys.
#
# There are two keys, the Secondary Manufacturer Public Key (SMPK) and the
# Backup Manufacturer Public Key (BMPK)
#
# For keywriter-lite based systems (am62l currently) the sha512 hash of the
# public key in DER format must be burned to the fuses. The hash files smpkh
# and bmpkh are generated here for convenience and documentation purposes as
# well.
#
# For production systems, you must generate your own secret release key.
#
set -e

function gen_key() {
	local t=$1

	openssl genrsa -traditional -out ${t}-development.priv.pem 4096
	openssl pkey -in ${t}-development.priv.pem -outform der -pubout > ${t}-development.pub.der
	openssl dgst -sha512 -binary ${t}-development.pub.der > ${t}-development.pub.der.sha512
}

gen_key bmpk
gen_key smpk
