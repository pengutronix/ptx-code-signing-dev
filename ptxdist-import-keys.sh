#!/bin/bash

set -e

import_fit_keys() {
	local fit_cert_dir=fit
	local r="image-kernel-fit"
	cs_define_role "${r}"
	cs_import_cert_from_der "${r}" "${fit_cert_dir}/fit-4096-development.crt"
	cs_import_pubkey_from_pem "${r}" "${fit_cert_dir}/fit-4096-development.key"
	cs_import_privkey_from_pem "${r}" "${fit_cert_dir}/fit-4096-development.key"
}

import_kernel_keys() {
	local kernel_key_dir=kernel
	local r="kernel-modules"
	cs_define_role "${r}"
	cs_import_cert_from_der "${r}" "${kernel_key_dir}/kernel-development.crt"
	cs_import_key_from_pem "${r}" "${kernel_key_dir}/kernel-development.key"
}

import_rauc_keys() {
	local rauc_cert_dir=rauc
	local r="update"
	cs_define_role "${r}"
	cs_import_cert_from_pem "${r}" "${rauc_cert_dir}/rauc.cert.pem"
	cs_import_pubkey_from_pem "${r}" "${rauc_cert_dir}/rauc.key.pem"
	cs_import_privkey_from_pem "${r}" "${rauc_cert_dir}/rauc.key.pem"
	cs_append_ca_from_uri "${r}"
}

import_imx_habv4_keys() {
	local imx_habv4_key_dir="habv4"
	local crts="${imx_habv4_key_dir}/crts"
	local keys="${imx_habv4_key_dir}/keys"
	local OPENSSL_KEYPASS="${imx_habv4_key_dir}/keys/key_pass.txt"
	local r g

	for i in 1 2 3 4; do
		r="imx-habv4-srk${i}"
		cs_define_role "${r}"
		cs_import_cert_from_der "${r}" "${crts}/SRK${i}_sha256_4096_65537_v3_ca_crt.der"
		cs_import_key_from_pem "${r}" "${keys}/SRK${i}_sha256_4096_65537_v3_ca_key.pem"
		cs_append_ca_from_uri "${r}"

		r="imx-habv4-csf${i}"
		cs_define_role "${r}"
		cs_import_cert_from_der "${r}" "${crts}/CSF${i}_1_sha256_4096_65537_v3_usr_crt.der"
		cs_import_key_from_pem "${r}" "${keys}/CSF${i}_1_sha256_4096_65537_v3_usr_key.pem"

		r="imx-habv4-img${i}"
		cs_define_role "${r}"
		cs_import_cert_from_der "${r}" "${crts}/IMG${i}_1_sha256_4096_65537_v3_usr_crt.der"
		cs_import_key_from_pem "${r}" "${keys}/IMG${i}_1_sha256_4096_65537_v3_usr_key.pem"
	done

	if [ "$(type -t cs_group_add_roles)" = "function" ]; then
		g="imx-habv4-srk"
		cs_define_group "${g}"
		for i in 1 2 3 4; do
			cs_group_add_roles "${g}" "imx-habv4-srk${i}"
		done

		g="imx-habv4-csf"
		cs_define_group "${g}"
		for i in 1 2 3 4; do
			cs_group_add_roles "${g}" "imx-habv4-csf${i}"
		done

		g="imx-habv4-img"
		cs_define_group "${g}"
		for i in 1 2 3 4; do
			cs_group_add_roles "${g}" "imx-habv4-img${i}"
		done
	fi
}

import_uefi_secure_boot_keys() {
	local sb_cert_dir="uefi-secure-boot"
	local r

	r="uefi-secure-boot-pk"
	cs_define_role "${r}"
	cs_import_cert_from_pem "${r}" "${sb_cert_dir}/PK.cert.pem"
	cs_import_pubkey_from_pem "${r}" "${sb_cert_dir}/PK.key.pem"
	cs_import_privkey_from_pem "${r}" "${sb_cert_dir}/PK.key.pem"
	cs_append_ca_from_uri "${r}"

	r="uefi-secure-boot-kek"
	cs_define_role "${r}"
	cs_import_cert_from_pem "${r}" "${sb_cert_dir}/KEK.cert.pem"
	cs_import_pubkey_from_pem "${r}" "${sb_cert_dir}/KEK.key.pem"
	cs_import_privkey_from_pem "${r}" "${sb_cert_dir}/KEK.key.pem"
	cs_append_ca_from_uri "${r}"

	r="uefi-secure-boot-db"
	cs_define_role "${r}"
	cs_import_cert_from_pem "${r}" "${sb_cert_dir}/db.cert.pem"
	cs_import_pubkey_from_pem "${r}" "${sb_cert_dir}/db.key.pem"
	cs_import_privkey_from_pem "${r}" "${sb_cert_dir}/db.key.pem"
	cs_append_ca_from_uri "${r}"
}

cs_init_softhsm
import_fit_keys
import_rauc_keys
import_kernel_keys
import_imx_habv4_keys
import_uefi_secure_boot_keys
