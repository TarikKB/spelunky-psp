FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    cmake \
    git \
    libsdl1.2-dev \
    libsdl-mixer1.2-dev \
    libglew-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work