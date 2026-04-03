FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PSPDEV=/usr/local/pspdev
ENV PSPSDK=${PSPDEV}/psp/sdk
ENV PATH=${PATH}:${PSPDEV}/bin:${PSPSDK}/bin

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        g++ \
        build-essential \
        autoconf \
        automake \
        cmake \
        doxygen \
        bison \
        flex \
        libncurses5-dev \
        libsdl1.2-dev \
        libsdl-mixer1.2-dev \
        libsdl2-dev \
        libreadline-dev \
        libusb-dev \
        texinfo \
        libgmp3-dev \
        libmpfr-dev \
        libelf-dev \
        libmpc-dev \
        libfreetype6-dev \
        zlib1g-dev \
        libtool \
        libtool-bin \
        subversion \
        git \
        tcl \
        unzip \
        wget \
        libcurl4-openssl-dev \
        libgpgme-dev \
        libarchive-dev \
        libssl-dev \
    && apt-get clean

WORKDIR /tmp
RUN git clone --depth 1 https://github.com/pspdev/psptoolchain.git

WORKDIR /tmp/psptoolchain
RUN ./toolchain.sh

WORKDIR /work