#!/bin/sh

set -e

vagrant destroy --force
vagrant box add --name docker-in-a-box ../vagrant-box-builder/output/ubuntu-server-amd64-docker.box
vagrant up
vagrant destroy --force
vagrant box remove docker-in-a-box
