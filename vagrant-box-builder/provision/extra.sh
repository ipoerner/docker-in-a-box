#!/bin/sh

set -e

for file in $(ls /tmp/provision_extra/*.sh 2> /dev/null); do
	echo "Executing $(basename ${file})..."
    sh $(readlink -f "${file}")
done
