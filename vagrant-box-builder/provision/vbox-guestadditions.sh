#!/usr/bin/env bash

set -e
set -o pipefail

# Install required packages
apt-get update
apt-get install -y --no-install-recommends \
    build-essential \
    dkms \
    linux-headers-generic \
    xorriso

# Clean target dir
rm -rf VBoxGuestAdditions && mkdir VBoxGuestAdditions

# Install VBoxGuestAdditions
osirrox \
    -indev /tmp/VBoxGuestAdditions.iso \
    -extract / \
    VBoxGuestAdditions
# The script always exits with an error, even in the case of success
/bin/sh VBoxGuestAdditions/VBoxLinuxAdditions.run --nox11 || echo "Deliberately ignoring return code: $?"

# Package cleanup
apt-get purge -y \
    build-essential \
    dkms \
    linux-headers-generic \
    xorriso
apt-get autoremove -y --purge
apt-get clean
