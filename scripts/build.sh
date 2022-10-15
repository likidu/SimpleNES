#!/bin/bash

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
BASE_DIR=$(dirname "$SCRIPT_DIR")

BUILD_DIR="$BASE_DIR/build"

mkdir -p $BUILD_DIR
rm -rf $BUILD_DIR/*

emcmake cmake -B$BUILD_DIR -GNinja -DBUILD_STATIC=true -DCMAKE_BUILD_TYPE=Release $BASE_DIR

emmake cmake --build $BUILD_DIR