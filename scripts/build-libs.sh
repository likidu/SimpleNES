#!/bin/bash

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
BASE_DIR=$(dirname "${SCRIPT_DIR}")

LIBS_DIR="${BASE_DIR}/libs"
LIBS_SRC_DIR="${LIBS_DIR}/sources"

rm -rf "${LIBS_SRC_DIR}"
mkdir -p "${LIBS_SRC_DIR}" && cd "${LIBS_SRC_DIR}"

# OpenAL-Soft is under the LGPL license
# stb_image and stb_image_write are public domain
# freetype is under the FreeType license or the GPL license
# libogg is under the BSD license
# libvorbis is under the BSD license
# libflac is under the BSD license
# minimp3 is under the CC0 license

CC=/usr/bin/clang-14
CXX=/usr/bin/clang++-14

CONFIG_ARGS=(
  --disable-shared
)

LIBOGG=libogg-1.3.5
LIBOGG_HASH="c4d91be36fc8e54deae7575241e03f4211eb102afb3fc0775fbbc1b740016705"

LIBVORBIS=libvorbis-1.3.7
LIBVORBIS_HASH="b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b"

LIBFLAC=flac-1.3.2
LIBFLAC_HASH="91cfc3ed61dc40f47f050a109b08610667d73477af6ef36dcad31c31a4a8d53f"

# libogg
if [ ! -f "${LIBOGG}".tar.xz ]; then
  echo "Downloading Lib OGG sources..."
  wget -c https://downloads.xiph.org/releases/ogg/"${LIBOGG}".tar.xz
fi
# Validate checksum
echo "Checksum ${LIBOGG}.tar.gz file..."
${SCRIPT_DIR}/validate-sha256sum.sh "${LIBOGG}".tar.xz "${LIBOGG_HASH}"

echo "Unpacking Lib OGG sources..."
tar xf "${LIBOGG}".tar.xz || exit 1
cd "${LIBS_SRC_DIR}/${LIBOGG}"

echo "Building Lib OGG..."
emconfigure ./configure "${CONFIG_ARGS[@]}" --prefix="${LIBS_DIR}/${LIBOGG}" || exit 1
emmake make -j4
emmake make install

# Back to source folder
cd "${LIBS_SRC_DIR}"

echo -e "\n================ Done building libogg ====================\n" 

# libvorbis
if [ ! -f "${LIBVORBIS}".tar.xz ]; then
  echo "Downloading Lib Vorbis sources..."
  wget -c https://downloads.xiph.org/releases/vorbis/"${LIBVORBIS}".tar.xz
fi
# Validate checksum
echo "Checksum ${LIBVORBIS}.tar.gz file..."
${SCRIPT_DIR}/validate-sha256sum.sh "${LIBVORBIS}".tar.xz "${LIBVORBIS_HASH}"

echo "Unpacking Lib Vorbis sources..."
tar xf "${LIBVORBIS}".tar.xz || exit 1
cd "${LIBS_SRC_DIR}/${LIBVORBIS}"

echo "Building Lib Vorbis..."
LD_LIBRARY_PATH="${LIBS_DIR}/${LIBOGG}/lib"
PKG_CONFIG_PATH="${LIBS_DIR}/${LIBOGG}/lib/pkgconfig"
emconfigure ./configure "${CONFIG_ARGS[@]}" --prefix="${LIBS_DIR}/${LIBVORBIS}" || exit 1
emmake make -j4
emmake make install
