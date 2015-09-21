#!/usr/bin/env bash

set -e
set -o pipefail

# Install Docker
wget -qO- https://get.docker.com/ | sh

# Add 'vagrant' user to 'docker' group
usermod -aG docker vagrant
