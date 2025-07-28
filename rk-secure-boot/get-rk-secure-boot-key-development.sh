#!/bin/sh
#
# A Rockchip rkimage may be signed with an RSA key with 2048 bits or 4096 bits.
# Use a 4096 bit key for development as an actual secret release key should
# prefer longer keys, too.
#
# For production systems, you must generate your own secret release key.
#
# To generate a key, you may use OpenSSL as done by this script for the
# development key, or the Rockchip Vendor tool:
#
# 	rk_sign_tool kk --bits=4096 --out .

set -e

openssl genrsa -f4 -out rk-development.key.pem 4096
