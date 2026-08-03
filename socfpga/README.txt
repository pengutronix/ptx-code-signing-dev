Agilex 5: Vendor Authorized Boot
--------------------------------

The Agilex 5 SoC uses a proprietary binary format with the .qky file extension
for certificate chains.

The qky that contains the root key (agilex5-ecdsa-development.qky) is used to
program the SDM firmware to accept only images that are signed with signing
keys that are signed with this root key.

When singing an image, the qky that ends with the signing key and is signed
with the root key (agilex5-ecdsa-development.qky) needs to be added to the
image to establish the chain of trust.

Download and install Quartus [0] to use the key generation script, since the
script depends on `quartus_sign` for QKY certificate generation.

[0] https://www.altera.com/products/development-tools/quartus
