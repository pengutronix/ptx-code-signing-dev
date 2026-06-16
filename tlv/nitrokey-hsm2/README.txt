Import TLV Signing Keys into NitroHSM2
--------------------------------------

To import keys into a SmartCard HSM/NitroHSM2, we need to wrap them as
encrypted PKCS#12 files, which also requires creating certificates. The
certificates are only used to satisfy the import requirements and are not
needed after import.

$ ./wrap-p12.sh

The resulting .p12 files can be imported using the "Smart Card Shell" GUI [1].
You need the DKEK share(s) with their corresponding password(s).

- start the scsh3gui and start the key manager (Ctrl-M)
- login using the User PIN
- right-click on top-level HSM node and select "Import from PKCS#12 (old)"
  - number of DKEK shares: "1"
  - DKEK share format: file (password)
  - filename containing DKEK share [2]:
    ".../ptx-code-signing-dev/nitrokey-hsm2/dkek-share-dev-1.pbe"
  - password for DKEK share [3]: "ptx-code-signing-dev"
  - PKCS#12 container:
    ".../ptx-code-signing-dev/tlv/nitrokey-hsm2/tlv-4096-development.p12"
    or:
    ".../ptx-code-signing-dev/tlv/nitrokey-hsm2/tlv-ecdsa-development.p12"
  - PKCS#12 password: "test"
  - confirm key selection (only one should be offered)
  - key name for import: "tlv-4096" or "tlv-ecdsa"
- repeat until all keys are imported

[1] https://www.openscdp.org/scsh3/index.html
[2] ../../nitrokey-hsm2/dkek-share-dev-1.pbe
[3] ../../nitrokey-hsm2/dkek-share-dev-1.password

To confirm the import, you can use pkcs11-tool -O:

...
Public Key Object; EC  EC_POINT 256 bits
  EC_POINT:   044104ba1c051fd7038757d036cf6fe9567ee0a19a7c03d7128076bff3a581e797213a0530db1522f20318a8b43e53dd2c2ceddaa11277f79b98fe5e07adf556d8ca5a
  EC_PARAMS:  06082a8648ce3d030107 (OID 1.2.840.10045.3.1.7)
  label:      tlv-ecdsa
  ID:         0a
...

Convert hex ID (0a) to decimal (10) when using it as a "key reference" for
sc-hsm-tool.

Use sc-hsm-tool to wrap the keys for import to other HSMs in the same DKEK
group:

$ sc-hsm-tool --wrap-key 'tlv-ecdsa.wky' --key-reference 10 --pin 123456

To use bareboxtlv-generator.py with this key, you need to enable the pkcs11
provider in your OpenSSL config:

$ export OPENSSL_CONF=openssl-pkcs11.cnf
$ cd barebox/scripts/bareboxtlv-generator && \
  ./bareboxtlv-generator.py \
  --input-data data-example.yaml \
  --sign "pkcs11:object=tlv-ecdsa" \
  schema-example.yaml \
  tlv.bin

