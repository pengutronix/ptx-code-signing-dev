Import SMPK/BMPK Signing Keys into NitroHSM2
--------------------------------------------

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
    ".../ptx-code-signing-dev/ti-k3/nitrokey-hsm2/smpk-development.p12"
    or:
    ".../ptx-code-signing-dev/ti-k3/nitrokey-hsm2/bmpk-development.p12"
  - PKCS#12 password: "test"
  - confirm key selection (only one should be offered)
  - key name for import: "ptx-dev-smpk" or "ptx-dev-bmpk"
- repeat until all keys are imported

[1] https://www.openscdp.org/scsh3/index.html
[2] ../../nitrokey-hsm2/dkek-share-dev-1.pbe
[3] ../../nitrokey-hsm2/dkek-share-dev-1.password

To confirm the import, you can use pkcs11-tool -O:

...
Public Key Object; RSA  4096 bits
  Modulus:    b5100944f58b79b[...]
  Public exp: 65537 (0x010001)
  label:      ptx-dev-smpk
  ID:         1 (0x01)
...

From the ID entry, use the decimal value when using it as a "key reference" for
sc-hsm-tool.

Use sc-hsm-tool to wrap the keys for import to other HSMs in the same DKEK
group:

$ sc-hsm-tool --wrap-key 'ptx-dev-smpk.wky' --key-reference 1 --pin 123456
