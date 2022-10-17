#!/bin/bash

LIBFLAC=flac-1.4.1
LIBFLAC_HASH="91303c3e5dfde52c3e94e75976c0ab3ee14ced278ab8f60033a3a12db9209ae6"

# https://github.com/mmig/libflac.js/blob/master/Makefile#L112
CONFIG_ARGS=(
  --enable-static
  --disable-shared
  --disable-asm-optimizations
  --disable-altivec
  --disable-doxygen-docs
  --disable-xmms-plugin
  --disable-cpplibs
  --disable-examples
  --with-ogg-libraries="$2/lib"
  --with-ogg-includes="$2/include"
  --prefix="$2"
)

# libflac
if [ ! -f "${LIBFLAC}".tar.xz ]; then
  echo "Downloading Lib FLAC sources..."
  wget -c https://downloads.xiph.org/releases/flac/"${LIBFLAC}".tar.xz
fi
# Validate checksum
echo "Checksum ${LIBFLAC}.tar.xz file..."
$1/validate_sha256sum.sh "${LIBFLAC}".tar.xz "${LIBFLAC_HASH}"

echo "Unpacking Lib FLAC sources..."
tar xf "${LIBFLAC}".tar.xz || exit 1
cd "${LIBFLAC}"

echo "Building Lib FLAC..."
emconfigure ./configure "${CONFIG_ARGS[@]}" || exit 1
emmake make -j4
emmake make install

echo -e "\n================ Done building flac ====================\n" 