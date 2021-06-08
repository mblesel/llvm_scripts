#!/usr/bin/env bash
set -e
set -u

# Set your system specific paths for the llvm git and the desired install path
: ${SRC_PATH:=/home/michael/Projects/llvm_src} # Where to put llvm git repo
: ${INSTALL_PREFIX:=/home/michael/Projects/llvm_install} # Install path for llvm
: ${CC:=gcc}
: ${CXX:=g++}

echo -e "LLVM will be installed in ${INSTALL_PREFIX}"
echo -e "CC=$CC"
echo -e "CXX=$CXX"

echo "Press <enter> to continue"
read
cd $SRC_PATH

# check if earlyoom is running
if [[ $(ps aux|grep earlyoom|grep -v grep|wc -l ) -eq 0 ]]; then
    echo -e "Earlyoom is not running! Continue? (y/n)"
    if read; then
        case ${REPLY} in
            y|Y|yes|Yes)
                ;;
            *)
                echo -e "Exit"
                exit 1
                ;;
        esac
    else
        echo -e "Unknown input"
        echo -e "Exit"
        exit 1
    fi
fi
sleep 1s

if [-d build]; then
    echo -e "Found existing build directory. Shall it be deleted? (y/n)"
    if read; then
        case ${REPLY} in
            y|Y|yes|Yes)
                rm -rf build
                echo -e "Deleted build directory$"
                ;;
            n|N|no|No)
                echo -e "Reuse existing build directory"
                ;;
            *)
                echo -e "Unknown input"
                echo -e "Exit"
                exit 1
                ;;
        esac
    else
        echo -e "Unknown input"
        echo -e "Exit"
        exit 1
    fi 
fi 

mkdir -p build
cd build

# Change the DLLVM_ENABLE_PROJECTS argument to decide which sub-project of llvm will be built
echo -e "Running CMake"
CC=${CC} CXX=${CXX} cmake -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;libunwind;lldb;compiler-rt;lld;polly;openmp" -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DLLVM_USE_LINKER=gold -G "Ninja" ../llvm

# attempt three full parallel builds to get as far as possible, start afterwards the "finally"-build with a single process
( (echo -e "\n\nFull parallel build (Attempt 1)\n\n"; \
sleep 1s; \
ninja -j $(nproc) ) || \
\
(echo -e "\n\n$Full parallel build (Attempt 2)\n\n"; \
sleep 1s; \
ninja -j $(nproc) ) || \
\
(echo -e "\n\nFull parallel build (Attempt 3)\n\n"; \
sleep 1s; \
ninja -j $(nproc) ) || \
\
(echo -e "\n\nSequential build\n\n"; \
sleep 1s; \
ninja -j 1) ) &&\
\
(echo -e "\n\nInstall LLVM into ${INSTALL_PREFIX}\n\n"; \
sleep 1s; \
ninja install)
