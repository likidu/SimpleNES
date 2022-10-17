#!/bin/bash

SCRIPTS_DIR=$(dirname $(readlink -f "$0"))
BASE_DIR=$(dirname "${SCRIPTS_DIR}")

LIBS_DIR="${BASE_DIR}/libs"
LIBS_SRC_DIR="${LIBS_DIR}/sources"

# rm -rf "${LIBS_SRC_DIR}"
mkdir -p "${LIBS_SRC_DIR}" && cd "${LIBS_SRC_DIR}"

# Build libogg
# bash $SCRIPTS_DIR/build_libogg.sh "$SCRIPTS_DIR" "$LIBS_DIR"
# Build libvorbis
# bash $SCRIPTS_DIR/build_libvorbis.sh "$SCRIPTS_DIR" "$LIBS_DIR"
# Build libflac
# bash $SCRIPTS_DIR/build_libflac.sh "$SCRIPTS_DIR" "$LIBS_DIR"
# Build brotli
# bash $SCRIPTS_DIR/build_brotli.sh "$SCRIPTS_DIR" "$LIBS_DIR"
# Build freetype
# bash $SCRIPTS_DIR/build_freetype2.sh "$SCRIPTS_DIR" "$LIBS_DIR"

# Build SFML
bash $SCRIPTS_DIR/build_sfml.sh "$SCRIPTS_DIR" "$LIBS_DIR"