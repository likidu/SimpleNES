#!/bin/bash

LIBVORBIS=libvorbis-1.3.7
LIBVORBIS_HASH="b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b"

CONFIG_ARGS=(
  --disable-shared
  --disable-docs
  --disable-examples
  --with-ogg-libraries="$2/lib"
  --with-ogg-includes="$2/include"
  --prefix="$2"
)

# libvorbis
if [ ! -f "${LIBVORBIS}".tar.xz ]; then
  echo "Downloading Lib Vorbis sources..."
  wget -c https://downloads.xiph.org/releases/vorbis/"${LIBVORBIS}".tar.xz
fi
# Validate checksum
echo "Checksum ${LIBVORBIS}.tar.xz file..."
$1/validate_sha256sum.sh "${LIBVORBIS}".tar.xz "${LIBVORBIS_HASH}"

echo "Unpacking Lib Vorbis sources..."
tar xf "${LIBVORBIS}".tar.xz || exit 1
cd "${LIBVORBIS}"

echo "Building Lib Vorbis..."
emconfigure ./configure "${CONFIG_ARGS[@]}" || exit 1
emmake make -j4
emmake make install

cd "$2/sources" || exit 1

echo -e "\n================ Done building libvorbis ====================\n" 