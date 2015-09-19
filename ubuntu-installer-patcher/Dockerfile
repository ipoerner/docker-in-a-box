############################################################
# Dockerfile for building a Debian Installer .iso file
# Based upon Ubuntu 14.04 (Trusty Tahr)
############################################################

# Set the base image to Ubuntu
FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER Ingmar Poerner

# Locale settings
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Update the repository sources list
RUN apt-get update -y && apt-get upgrade -y

# Install most common dev tools
RUN apt-get update -y && apt-get install -y --no-install-recommends \
	curl \
	genisoimage \
	syslinux \
    xorriso

ENV UBUNTU_SERVER_VERSION 14.04.3
ENV UBUNTU_SERVER_FILENAME ubuntu-${UBUNTU_SERVER_VERSION}-server-amd64
ENV UBUNTU_INSTALLER_PATH /usr/share/ubuntu-installer

# Generate directory tree
RUN rm -rf ${UBUNTU_INSTALLER_PATH} && \
    mkdir -p ${UBUNTU_INSTALLER_PATH} && \
    mkdir ${UBUNTU_INSTALLER_PATH}/patches/ && \
    mkdir ${UBUNTU_INSTALLER_PATH}/patches/preseed && \
    mkdir ${UBUNTU_INSTALLER_PATH}/patches/isolinux

# Fetch original installer ISO
RUN curl \
        --show-error \
        --location \
        --output ${UBUNTU_INSTALLER_PATH}/ubuntu-server-amd64.iso \
        http://releases.ubuntu.com/${UBUNTU_SERVER_VERSION}/${UBUNTU_SERVER_FILENAME}.iso

# Copy patches
COPY isolinux/*.* ${UBUNTU_INSTALLER_PATH}/patches/isolinux/
COPY preseed/${UBUNTU_SERVER_FILENAME}.seed ${UBUNTU_INSTALLER_PATH}/patches/preseed/ubuntu-server-amd64.seed

ENV UBUNTU_INSTALLER_WORKDIR /mnt/ubuntu-installer-patch
VOLUME ${UBUNTU_INSTALLER_WORKDIR}

# Copy the script
COPY patch-ubuntu-installer.sh ${UBUNTU_INSTALLER_WORKDIR}/

WORKDIR ${UBUNTU_INSTALLER_WORKDIR}
ENTRYPOINT ./patch-ubuntu-installer.sh
