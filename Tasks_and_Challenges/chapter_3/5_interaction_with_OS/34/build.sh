#!/usr/bin/env bash
set -e

FILES=("main" "str")

NASM_FLAGS="-f elf32"

BUILD_DIR="build"
mkdir -p $BUILD_DIR

for f in "${FILES[@]}"; do
  nasm $NASM_FLAGS "$f.asm" -o "$BUILD_DIR/$f.o"
done

OBJ=""
for f in "${FILES[@]}"; do
  OBJ+="$BUILD_DIR/$f.o "
done

ld -m elf_i386 $OBJ -o ./$BUILD_DIR/26
