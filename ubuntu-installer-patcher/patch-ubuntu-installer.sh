#!/bin/sh

set -e

# Clean target dir
rm -rf ubuntu-server-amd64-patched && mkdir ubuntu-server-amd64-patched

# Extract installer
osirrox \
    -indev ${UBUNTU_INSTALLER_PATH}/ubuntu-server-amd64.iso \
    -extract / \
    ubuntu-server-amd64-patched

# Inject patches
cp -R ${UBUNTU_INSTALLER_PATH}/patches/* ubuntu-server-amd64-patched/

# # Patch initrd.gz with custom preseed file
# mkdir initrd
# (
#    cd initrd
# 
#    orig_initrd=../ubuntu-server-amd64-patched/install/initrd.gz
#    custom_preseed=${UBUNTU_INSTALLER_PATH}/patches/preseed/ubuntu-server-amd64.seed
# 
#    gzip -d < ${orig_initrd} \
#        | cpio --extract --verbose --make-directories --no-absolute-filenames
#    cp ${custom_preseed} preseed.cfg
#    rm -rf ${orig_initrd}
#    find . \
#        | cpio -H newc --create --verbose \
#        | gzip -9 > ${orig_initrd}
# )

# Update checksum
(
    cd ubuntu-server-amd64-patched
    md5sum `find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f` > md5sum.txt
)

# Generate new ISO file
rm -f /mnt/share/ubuntu-server-amd64-patched.iso
genisoimage \
    -r \
    -J \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -o /mnt/share/ubuntu-server-amd64-patched.iso \
    ubuntu-server-amd64-patched
isohybrid /mnt/share/ubuntu-server-amd64-patched.iso
