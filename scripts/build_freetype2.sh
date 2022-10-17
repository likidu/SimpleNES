#!/bin/bash

FREETYPE=freetype2

# TODO: Enable brotli for woff2 support
# https://github.com/Ciantic/freetype-wasm/blob/master/build_freetype.sh
CONFIG_ARGS=(
  -DCMAKE_BUILD_TYPE=Release
  # -DBROTLIDEC_LIBRARIES="$2/lib"
  # -DBROTLIDEC_INCLUDE_DIRS="$2/include"
  -DFT_DISABLE_ZLIB=TRUE
  -DFT_DISABLE_BZIP2=TRUE
  -DFT_DISABLE_PNG=TRUE
  -DFT_DISABLE_HARFBUZZ=TRUE
  -DFT_REQUIRE_BROTLI=FALSE
  -DCMAKE_INSTALL_PREFIX="$2"
)

# freetype2
if [ ! -d "$2/sources/$FREETYPE" ]; then
  echo "Clone Freetype sources..."
  git clone https://github.com/freetype/freetype "$FREETYPE"
fi

cd "$FREETYPE"

echo "Building Freetype..."
rm -rf build && mkdir build && cd build || exit 1
emcmake cmake "${CONFIG_ARGS[@]}" .. || exit 1
emmake make
emmake make install

cd "$2/sources" || exit 1

echo -e "\n================ Done building freetype2 ====================\n" 