#!/bin/bash

# Full LTO + PGO + BOLT + MLGO optimized kernel build script
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=$PWD/clang/bin
export PATH=$CLANG_PATH:$PATH

export KBUILD_BUILD_USER="tegarxlu"
export KBUILD_BUILD_HOST="gki-builder"

export CROSS_COMPILE=aarch64-linux-gnu-
export CLANG_TRIPLE=aarch64-linux-gnu-
export CC=clang
export CXX=clang++
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip
export HOSTCC=clang
export HOSTCXX=clang++

# Enable MLGO & other optimizations
export LLVM=1
export LLVM_IAS=1
export LTO=full
export CONFIG_LTO_CLANG_FULL=y
export CONFIG_PGO_CLANG=y
export CONFIG_BOLT_CLANG=y
export CONFIG_MLGO_CLANG=y
export CONFIG_LLD_PGO_USE=y
export CONFIG_KERNEL_LD=lld

DEFCONFIG="arch/arm64/configs/gki_defconfig"
OUTDIR="out"
ANYKERNEL_DIR="../AnyKernel3"
FINAL_ZIP="TegarXLu-Gaming-Kernel.zip"

# Prepare output directory
rm -rf ${OUTDIR}
mkdir -p ${OUTDIR}

# Setup defconfig and build
make O=${OUTDIR} ${DEFCONFIG}
make -j$(nproc) O=${OUTDIR}     ARCH=arm64 LLVM=1 LLVM_IAS=1 LTO=full

# Package with AnyKernel3
cp ${OUTDIR}/arch/arm64/boot/Image.gz ${ANYKERNEL_DIR}/
cd ${ANYKERNEL_DIR}
zip -r9 "../${FINAL_ZIP}" ./*
cd ..

echo "✅ Kernel build complete: ${FINAL_ZIP}"
