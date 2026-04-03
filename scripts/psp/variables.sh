#!/usr/bin/env bash

set -e
set -u

ROOT_PATH=$(realpath ../../)
TMP_PATH=$ROOT_PATH/tmp
INSTALL_PATH=$TMP_PATH/install-psp
BUILD_PATH=$TMP_PATH/build-psp

if command -v nproc >/dev/null 2>&1; then
  NUM_THREADS=$(nproc)
else
  NUM_THREADS=$(sysctl -n hw.logicalcpu)
fi