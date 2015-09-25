#!/bin/sh

set -e

# Fetch Packer scripts
cp -R ${VAGRANT_BOX_PATH}/* .

# Build Vagrant box
ubuntu_installer_path="/mnt/share/ubuntu-server-amd64-patched.iso"
ubuntu_installer_md5=$(md5sum ${ubuntu_installer_path} | awk '{print $1}')
output="/mnt/output/ubuntu-server-amd64-custom.box"

packer build \
    -var "ubuntu_installer_path=${ubuntu_installer_path}" \
    -var "ubuntu_installer_md5=${ubuntu_installer_md5}" \
    -var "output=${output}" \
    grow-a-box.json
