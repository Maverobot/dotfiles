#!/usr/bin/env bash

INSTALL_PREFIX=${1:-~/.local}
VERSION=${2:-1.0.0}

[ ! -d $INSTALL_PREFIX ] && echo "Install prefix path ($INSTALL_PREFIX) does not exist. Exiting..." && exit 1

curl -SL "https://github.com/facebook/infer/releases/download/v$VERSION/infer-linux64-v$VERSION.tar.xz" \
    | sudo tar -C $INSTALL_PREFIX -xJ && \
    ln -s "$INSTALL_PREFIX/infer-linux64-v$VERSION/bin/infer" "$INSTALL_PREFIX/bin/infer"
