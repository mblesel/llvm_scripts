#!/usr/bin/env bash

set -e
set -u

SRC=$(pwd)

LLVM_SRC=${SRC}/llvm_src
TOOLS_SRC=${LLVM_SRC}/tools
PROJECTS_SRC=${LLVM_SRC}/projects


echo -e "\nClone LLVM"
git clone --depth=1 http://llvm.org/git/llvm.git ${LLVM_SRC}

echo -e "\nClone Clang"
git clone --depth=1 http://llvm.org/git/clang.git ${TOOLS_SRC}/clang

echo -e "\nClone lld"
git clone --depth=1 http://llvm.org/git/lld.git ${TOOLS_SRC}/lld

echo -e "\nClone Polly"
git clone --depth=1 http://llvm.org/git/polly.git ${TOOLS_SRC}/polly

echo -e "\nClone Compiler-rt"
git clone --depth=1 http://llvm.org/git/compiler-rt.git ${PROJECTS_SRC}/compiler-rt

echo -e "\nClone OpenMP"
git clone --depth=1 http://llvm.org/git/openmp.git ${PROJECTS_SRC}/openmp

echo -e "\nClone libcxx and libcxxabi"
git clone --depth=1 http://llvm.org/git/libcxx.git ${PROJECTS_SRC}/libcxx
git clone --depth=1 http://llvm.org/git/libcxxabi.git ${PROJECTS_SRC}/libcxxabi

echo -e "\nClone Test Suite"
git clone --depth=1 http://llvm.org/git/test-suite.git ${PROJECTS_SRC}/test-suite

echo -e "\nClone Clang-tools-extra"
git clone --depth=1 http://llvm.org/git/clang-tools-extra.git ${TOOLS_SRC}/clang/tools/extra






