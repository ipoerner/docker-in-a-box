############################################################
# Dockerfile for a Packer build environment
# Based upon Ubuntu 14.04 (Trusty Tahr)
############################################################

# Set the base image to Ubuntu
FROM ubuntu:14.04

# Author / Maintainer
MAINTAINER Ingmar Poerner

# Locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update -y && apt-get upgrade -y

# Install required packages
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    curl \
    dkms \
    linux-headers-generic \
    unzip

# Install VirtualBox
ENV VBOX_VERSION 4.3
RUN echo "deb http://download.virtualbox.org/virtualbox/debian vivid contrib" >> /etc/apt/sources.list && \
    curl -SL --insecure -o /tmp/oracle_vbox.asc https://www.virtualbox.org/download/oracle_vbox.asc && \
    apt-key add /tmp/oracle_vbox.asc && apt-get update -y
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    virtualbox-${VBOX_VERSION}

# Install Packer
ENV PACKER_VERSION 0.8.6
RUN packer_url=https://dl.bintray.com/mitchellh/packer/packer_${PACKER_VERSION}_linux_amd64.zip && \
    curl --show-error \
        --insecure \
        --location \
        --output /tmp/packer_linux_amd64.zip \
        ${packer_url} && \
    unzip /tmp/packer_linux_amd64.zip -d /usr/local/bin && \
    rm -f /tmp/packer_linux_amd64.zip

# Set up build environment
ENV VAGRANT_BOX_PATH /usr/share/vagrant-box-build

RUN rm -rf ${VAGRANT_BOX_PATH} && \
    mkdir -p ${VAGRANT_BOX_PATH} && \
    mkdir ${VAGRANT_BOX_PATH}/contrib && \
    mkdir ${VAGRANT_BOX_PATH}/provision && \
    mkdir ${VAGRANT_BOX_PATH}/provision/extra
RUN curl --show-error \
        --insecure \
        --location \
        --output ${VAGRANT_BOX_PATH}/contrib/vagrant.pub \
        https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
COPY provision ${VAGRANT_BOX_PATH}/provision/
COPY provision/extra ${VAGRANT_BOX_PATH}/provision/extra/
COPY docker-in-a-box.json ${VAGRANT_BOX_PATH}/

ENV PACKER_WORKDIR /mnt/vagrant-box-build
VOLUME ${PACKER_WORKDIR}

# Copy the script
COPY build-vagrant-box.sh ${PACKER_WORKDIR}/

WORKDIR ${PACKER_WORKDIR}
ENTRYPOINT ./build-vagrant-box.sh
