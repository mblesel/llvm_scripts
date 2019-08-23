#!/usr/bin/env bash

set -e
set -u

#module purge
#spack load gcc
#spack load cmake

CC=gcc
CXX=g++
CXXFLAGS="-std=c++17"

LLVM_BUILD=$(pwd)/llvm_build
LLVM_SRC=$(pwd)/llvm_src
LLVM_INSTALL=$(pwd)/llvm_install
INSTALL_LOG=$(pwd)/log_llvm_install.log 

mkdir -p $LLVM_BUILD
cd $LLVM_BUILD

cmake $LLVM_SRC -G "Unix Makefiles" \
    -DCMAKE_CXX_STANDARD=17 \
    -DCLANG_DEFAULT_CXX_STDLIB=libstdc++ \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_ENABE_WERROR=OFF \
    -DCMAKE_BUILD_TYPE=DEBUG \
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPPILER=$CXX \
    -DCMAKE_CXX_FLAGS_RELEASE=$CXXFLAGS \
    -DCMAKE_INSTALL_PREFIX=$LLVM_INSTALL \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON | tee --append $INSTALL_LOG

make 

make install


