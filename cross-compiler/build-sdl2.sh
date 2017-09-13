#!/usr/bin/env bash

function fail() {
  echo "$@"
  exit 1
}

# Change working directory to the directory this script is in.
cd "$(dirname "$(realpath $0)")"

PREFIX=$(pwd)
TOOLSET=x86_64-w64-mingw32
export CC="$TOOLSET-gcc -static-libgcc"


mkdir $PREFIX || fail "Couldn't create $PREFIX directory."

hg clone https://hg.libsdl.org/SDL SDL && cd SDL || fail "Couldn't clone SDL repository."

mkdir build-win64 && cd $_ || fail "Couldn't create build-win64 directory."

../configure --target=$TOOLSET --host=$TOOLSET \
             --build=x86_64-linux --prefix=$PREFIX/$TOOLSET || fail "Failed to run ./configure for cross-compiled SDL for Windows."

make || fail "Failed to build cross-compiled SDL for Windows."
make install || fail "Failed to install cross-compiled SDL for Windows."
