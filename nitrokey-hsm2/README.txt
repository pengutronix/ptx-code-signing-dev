Initialize HSM with DKEK Share
------------------------------

$ sc-hsm-tool --initialize --so-pin 3537363231383830 --pin 123456 --dkek-shares 1
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
$ sc-hsm-tool 
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Version              : 3.4
Config options       :
  User PIN reset with SO-PIN enabled
SO-PIN tries left    : 15
User PIN tries left  : 3
DKEK shares          : 1
DKEK import pending, 1 share(s) still missing
$ cat dkek-share-dev-1.password 
ptx-code-signing-dev
$ sc-hsm-tool --import-dkek-share dkek-share-dev-1.pbe 
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Enter password to decrypt DKEK share : ptx-code-signing-dev

Deciphering DKEK share, please wait...
DKEK share imported
DKEK shares          : 1
DKEK key check value : D2F16CD233B4EF7F
$ cat dkek-share-dev-1.check-value 
D2F16CD233B4EF7F
$ sc-hsm-tool 
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Version              : 3.4
Config options       :
  User PIN reset with SO-PIN enabled
SO-PIN tries left    : 15
User PIN tries left  : 3
DKEK shares          : 1
DKEK key check value : D2F16CD233B4EF7F
$ pkcs11-tool -O
Using slot 0 with a present token (0x0)


Import Wrapped Keys
-------------------
$ ls
 dkek-share-dev-1.check-value  'ptx-dev-CSF1_1(5).wky'  'ptx-dev-SRK2(2).wky'  'ptx-dev-fit(7).wky'
 dkek-share-dev-1.password     'ptx-dev-IMG1_1(6).wky'  'ptx-dev-SRK3(3).wky'  'ptx-dev-rauc(8).wky'
 dkek-share-dev-1.pbe          'ptx-dev-SRK1(1).wky'    'ptx-dev-SRK4(4).wky'
$ sc-hsm-tool --unwrap-key 'ptx-dev-SRK1(1).wky' --key-reference 1 --pin 123456
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Wrapped key contains:
  Key blob
  Private Key Description (PRKD)
  Certificate
Key successfully imported
$ pkcs11-tool -O
Using slot 0 with a present token (0x0)
Certificate Object; type = X.509 cert
  label:      ptx-dev-SRK1
  subject:    DN: CN=SRK1_sha256_4096_65537_v3_ca
  ID:         01
Public Key Object; RSA 4096 bits
  label:      ptx-dev-SRK1
  ID:         01
  Usage:      encrypt, verify
$ sc-hsm-tool --unwrap-key 'ptx-dev-SRK2(2).wky' --key-reference 2 --pin 123456
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Wrapped key contains:
  Key blob
  Private Key Description (PRKD)
  Certificate
Key successfully imported
$ sc-hsm-tool --unwrap-key 'ptx-dev-SRK3(3).wky' --key-reference 3 --pin 123456
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Wrapped key contains:
  Key blob
  Private Key Description (PRKD)
  Certificate
Key successfully imported
$ sc-hsm-tool --unwrap-key 'ptx-dev-SRK4(4).wky' --key-reference 4 --pin 123456
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Wrapped key contains:
  Key blob
  Private Key Description (PRKD)
  Certificate
Key successfully imported
$ sc-hsm-tool --unwrap-key 'ptx-dev-CSF1_1(5).wky' --key-reference 5 --pin 123456
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Wrapped key contains:
  Key blob
  Private Key Description (PRKD)
  Certificate
Key successfully imported
$ sc-hsm-tool --unwrap-key 'ptx-dev-IMG1_1(6).wky' --key-reference 6 --pin 123456
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Wrapped key contains:
  Key blob
  Private Key Description (PRKD)
  Certificate
Key successfully imported
$ sc-hsm-tool --unwrap-key 'ptx-dev-fit(7).wky' --key-reference 7 --pin 123456
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Wrapped key contains:
  Key blob
  Private Key Description (PRKD)
  Certificate
Key successfully imported
$ sc-hsm-tool --unwrap-key 'ptx-dev-rauc(8).wky' --key-reference 8 --pin 123456
Using reader with a card: Nitrokey Nitrokey HSM (DENK01035600000         ) 00 00
Wrapped key contains:
  Key blob
  Private Key Description (PRKD)
  Certificate
Key successfully imported


Verify Successful Import
------------------------

$ pkcs11-tool -O
Using slot 0 with a present token (0x0)
Certificate Object; type = X.509 cert
  label:      ptx-dev-SRK1
  subject:    DN: CN=SRK1_sha256_4096_65537_v3_ca
  ID:         01
Public Key Object; RSA 4096 bits
  label:      ptx-dev-SRK1
  ID:         01
  Usage:      encrypt, verify
Certificate Object; type = X.509 cert
  label:      ptx-dev-SRK2
  subject:    DN: CN=SRK2_sha256_4096_65537_v3_ca
  ID:         02
Public Key Object; RSA 4096 bits
  label:      ptx-dev-SRK2
  ID:         02
  Usage:      encrypt, verify
Certificate Object; type = X.509 cert
  label:      ptx-dev-SRK3
  subject:    DN: CN=SRK3_sha256_4096_65537_v3_ca
  ID:         03
Public Key Object; RSA 4096 bits
  label:      ptx-dev-SRK3
  ID:         03
  Usage:      encrypt, verify
Certificate Object; type = X.509 cert
  label:      ptx-dev-SRK4
  subject:    DN: CN=SRK4_sha256_4096_65537_v3_ca
  ID:         04
Public Key Object; RSA 4096 bits
  label:      ptx-dev-SRK4
  ID:         04
  Usage:      encrypt, verify
Certificate Object; type = X.509 cert
  label:      ptx-dev-CSF1_1
  subject:    DN: CN=CSF1_1_sha256_4096_65537_v3_usr
  ID:         05
Public Key Object; RSA 4096 bits
  label:      ptx-dev-CSF1_1
  ID:         05
  Usage:      encrypt, verify
Certificate Object; type = X.509 cert
  label:      ptx-dev-IMG1_1
  subject:    DN: CN=IMG1_1_sha256_4096_65537_v3_usr
  ID:         06
Public Key Object; RSA 4096 bits
  label:      ptx-dev-IMG1_1
  ID:         06
  Usage:      encrypt, verify
Certificate Object; type = X.509 cert
  label:      ptx-dev-fit
  subject:    DN: O=Pengutronix, CN=Development signing key/emailAddress=debug@pengutronix.de
  ID:         07
Public Key Object; RSA 4096 bits
  label:      ptx-dev-fit
  ID:         07
  Usage:      encrypt, verify
Certificate Object; type = X.509 cert
  label:      ptx-dev-rauc
  subject:    DN: O=Test Org, CN=Test Org Provisioning CA Root
  ID:         08
Public Key Object; RSA 2048 bits
  label:      ptx-dev-rauc
  ID:         08
  Usage:      encrypt, verify
