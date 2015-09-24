#!/bin/sh

set -e

OUTPUT_TARGET="${PWD}/output"

container_cleanup() {
    container_id=$(docker ps --all --quiet --filter "name=${1}")
    if ! [ -z "${container_id}" ]; then
        docker rm \
            --force \
            --volumes \
            ${container_id}
    fi
}

cleanup_all() {
    container_cleanup "build-vagrant-box"
    container_cleanup "patch-ubuntu-installer"
}

cleanup_all

(
    cd ubuntu-installer-patcher

    docker build \
        --tag ubuntu-installer-patcher \
        --force-rm \
        . \
        || cleanup_all

    docker run \
        --name patch-ubuntu-installer \
        --volume /mnt/share/ \
        ubuntu-installer-patcher \
        || cleanup_all
)

PROVISION_EXTRA_DIRECTORY="vagrant-box-builder/provision/extra"
rm -rf "${PROVISION_EXTRA_DIRECTORY}"
mkdir -p "${PROVISION_EXTRA_DIRECTORY}"
for file in $(ls provision_extra/*.sh 2> /dev/null); do
    cp -f "provision_extra/${file}" "${PROVISION_EXTRA_DIRECTORY}"
done

(
    cd vagrant-box-builder

    docker build \
        --tag vagrant-box-builder \
        --force-rm \
        . \
        || cleanup_all

    docker run \
        --name build-vagrant-box \
        --privileged \
        --rm \
        --volume "${OUTPUT_TARGET}:/mnt/output" \
        --volumes-from patch-ubuntu-installer \
        vagrant-box-builder \
        || cleanup_all
)

cleanup_all
