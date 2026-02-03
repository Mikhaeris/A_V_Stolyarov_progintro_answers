#!/usr/bin/env bash
set -e

FILES=("main" "message")

NASM_FLAGS="-f elf32"
LD_FLAGS="-m elf_i386"

BUILD_TYPE=${1:-Debug}
BUILD_DIR="build/$(echo "$BUILD_TYPE" | tr 'A-Z' 'a-z')"
mkdir -p $BUILD_DIR

if [ "$BUILD_TYPE" = "Debug" ]; then
  NASM_FLAGS="$NASM_FLAGS -g -F dwarf"
elif [ "$BUILD_TYPE" = "Release" ]; then
  NASM_FLAGS="$NASM_FLAGS"
else
  echo "Unknown build type: $BUILD_TYPE"
  exit 1
fi

for f in "${FILES[@]}"; do
  nasm $NASM_FLAGS "$f.asm" -o "$BUILD_DIR/$f.o"
done

OBJ=""
for f in "${FILES[@]}"; do
  OBJ+="$BUILD_DIR/$f.o "
done

ld $LD_FLAGS $OBJ -o ./$BUILD_DIR/26

echo "Build complete!"
