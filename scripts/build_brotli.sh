#!/bin/bash

BROTLI=brotli-1.0.9

CONFIG_ARGS=(
  -DCMAKE_BUILD_TYPE=Release
  -DCMAKE_INSTALL_PREFIX="$2"
)

# brotli
if [ ! -f "${BROTLI}".tar.gz ]; then
  echo "Downloading Brotli sources..."
  wget -c -O "$BROTLI".tar.gz https://github.com/google/brotli/archive/refs/tags/v1.0.9.tar.gz
fi

echo "Unpacking Brotli sources..."
tar xzf "${BROTLI}".tar.gz || exit 1
cd "${BROTLI}"

echo "Building Brotli..."
rm -rf build && mkdir build && cd build || exit 1
emcmake cmake "${CONFIG_ARGS[@]}" .. || exit 1
emmake make -j4
# emmake make install

# Manually copy files to lib folder as make install seems not working by default
cp -rf *.a "$2/lib/."
cp -rf *.pc "$2/lib/pkgconfig/."

cd "$2/sources" || exit 1

echo -e "\n================ Done building brotli ====================\n" 