#!/usr/bin/env bash

set -e
set -o pipefail

PUBLIC_KEY="/tmp/vagrant.pub"
SSH_DIR="/home/vagrant/.ssh"
SUDOERS_TMP="/tmp/vagrant.sudoers"

# New user 'vagrant'
useradd --create-home --shell /bin/bash vagrant
echo vagrant:vagrant | chpasswd

# Copy public key for 'vagrant' user
mkdir -p ${SSH_DIR}
chown vagrant:vagrant ${SSH_DIR}
chmod 0700 ${SSH_DIR}

mv -f ${PUBLIC_KEY} ${SSH_DIR}/authorized_keys
chown vagrant:vagrant ${SSH_DIR}/authorized_keys
chmod 0600 ${SSH_DIR}/authorized_keys

# Grant sudo rights to 'vagrant' user
cp -f /etc/sudoers ${SUDOERS_TMP}
cat >> ${SUDOERS_TMP} <<EOF

# Grant sudo rights to vagrant user
vagrant ALL=(ALL) NOPASSWD: ALL
EOF
visudo -c -f ${SUDOERS_TMP}
cp -f ${SUDOERS_TMP} /etc/sudoers
rm -f ${SUDOERS_TMP}
