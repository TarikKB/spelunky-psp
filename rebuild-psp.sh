#!/usr/bin/env bash
set -e

docker run --rm -it --platform linux/amd64 \
  -v "$PWD:/build" \
  -w /build \
  spelunky-psp/spelunky-psp:latest \
  sh -lc '
    export PSPDEV=/usr/local/pspdev
    export PATH="$PATH:$PSPDEV/bin"
    cd /build/scripts/psp
    [ -d ../../tmp/build-psp ] || ./config.sh
    ./build.sh
  '