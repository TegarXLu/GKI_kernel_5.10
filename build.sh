#!/bin/bash

# Script For Building Gaming-Optimized Android Kernel with Full LTO + PGO + BOLT + MLGO

DIR=$(readlink -f .)
MAIN=$(readlink -f ${DIR}/..)
export CLANG_PATH=$MAIN/clang-r536625/bin
export PATH=${CLANG_PATH}:${PATH}

DEFCONFIG="gki_gaming_defconfig"
DEVICE=garnet
THREAD="-j$(nproc --all)"
DATE=$(TZ=Asia/Jakarta date +"%Y%m%d-%T")
TANGGAL=$(date +"%F%S")
ANYKERNEL3_DIR=$PWD/AnyKernel3/
FINAL_KERNEL_ZIP=GamingWakaca-${DEVICE}-${TANGGAL}.zip

export ARCH=arm64
export SUBARCH=$ARCH
export KBUILD_BUILD_USER=byben
export KBUILD_BUILD_HOST=wkcw
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=$MAIN/clang-r536625/bin/aarch64-linux-gnu-
export CC=clang
export CXX=clang++

# MLGO optimization
export MLGO=1

# Clean
mkdir -p out
make O=out clean

# Configure for gaming defconfig
make O=out $DEFCONFIG LLVM=1 LLVM_IAS=1

# Full LTO + PGO + BOLT + MLGO Build
make O=out $THREAD \
    CC=ccache clang CXX=ccache clang++ \
    LLVM=1 LLVM_IAS=1 \
    CONFIG_LTO_CLANG=y CONFIG_LTO_CLANG_FULL=y CONFIG_LTO_CLANG_THIN=n \
    CONFIG_PGO_CLANG=y CONFIG_BOLT_CLANG=y CONFIG_MLGO_CLANG=y \
    CONFIG_LLD_PGO_USE=y CONFIG_KERNEL_LD=lld \
    2>&1 | tee kernel.log

# Package
ls out/arch/arm64/boot/Image.gz

cd $ANYKERNEL3_DIR
rm -f Image.gz dtbo.img dtb.img $FINAL_KERNEL_ZIP
cp $PWD/out/arch/arm64/boot/Image.gz ./
zip -r9 "../$FINAL_KERNEL_ZIP" * -x README $FINAL_KERNEL_ZIP
cd ..
rm -rf out kernel.log

sha1sum $FINAL_KERNEL_ZIP

echo "Build completed in $(($(date +"%s") - BUILD_START)) seconds."
