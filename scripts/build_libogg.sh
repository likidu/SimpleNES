#!/bin/bash

LIBOGG=libogg-1.3.5
LIBOGG_HASH="c4d91be36fc8e54deae7575241e03f4211eb102afb3fc0775fbbc1b740016705"

CONFIG_ARGS=(
  --disable-shared
  --prefix="$2"
)

# libogg
if [ ! -f "${LIBOGG}".tar.xz ]; then
  echo "Downloading Lib OGG sources..."
  wget -c https://downloads.xiph.org/releases/ogg/"${LIBOGG}".tar.xz
fi
# Validate checksum
echo "Checksum ${LIBOGG}.tar.xz file..."
$1/validate_sha256sum.sh "${LIBOGG}".tar.xz "${LIBOGG_HASH}"

echo "Unpacking Lib OGG sources..."
tar xf "${LIBOGG}".tar.xz || exit 1
cd "${LIBOGG}"

echo "Building Lib OGG..."
emconfigure ./configure "${CONFIG_ARGS[@]}" || exit 1
emmake make -j4
emmake make install

cd "$2/sources" || exit 1

echo -e "\n================ Done building libogg ====================\n" 