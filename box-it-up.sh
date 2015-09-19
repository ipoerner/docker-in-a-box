#!/bin/sh

set -e

container_cleanup() {
    container_id=$(docker ps --all --quiet --filter "name=${1}")
    if ! [ -z "${container_entry}" ]; then
        docker rm --force --volumes ${container_id}
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
        --volume $(pwd)/output:/mnt/output \
        --volumes-from patch-ubuntu-installer \
        vagrant-box-builder \
        || cleanup_all
)

cleanup_all
