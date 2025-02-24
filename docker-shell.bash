#!/usr/bin/env bash

docker run -it \
    -v $PWD:/root \
    -w /root \
    -e NIX_CONFIG='experimental-features = nix-command flakes' \
    -e BUILD_DIR=/root/build \
    nixos/nix bash
