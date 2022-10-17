#!/bin/bash

SFML=SFML-2.5.1

CONFIG_ARGS=(
  -DCMAKE_BUILD_TYPE=Release
  -DBUILD_SHARED_LIBS=FALSE
  -DSFML_BUILD_DOC=FALSE
  -DSFML_BUILD_NETWORK=FALSE
  -DCMAKE_INSTALL_PREFIX="$2"
)

# SFML
if [ ! -f "${SFML}"-sources.zip ]; then
  echo "Downloading SFML sources..."
  wget -c https://www.sfml-dev.org/files/"${SFML}"-sources.zip
fi

if [ ! -d "${SFML}" ]; then
  echo "Unpacking SFML sources..."
  unzip -q "${SFML}"-sources.zip || exit 1
fi

cd "${SFML}"

echo "Building SFML..."
rm -rf build && mkdir build && cd build || exit 1
emcmake cmake "${CONFIG_ARGS[@]}" .. || exit 1
emmake make sfml-system
emmake make install

cd "$2/sources" || exit 1

echo -e "\n================ Done building libogg ====================\n" 