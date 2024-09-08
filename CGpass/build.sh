#!/bin/bash

Action=$1
Target=CGpass
TargetPath=$(pwd)

# Clean action
if [ "$Action" == "clean" ]; then
    if [ -d "build" ]; then
        rm -rf build
    fi
    exit 0
fi

# Create symbolic link
PassDir=$LLVM_PATH/llvm-14.0.6.src/lib/Transforms
if [ ! -L "$PassDir/$Target" ]; then
    cd $PassDir || { echo "Failed to change directory to $PassDir"; exit 1; }
    ln -s $TargetPath $Target
    cd -
fi

# Ensure CGpass is in CMakeLists.txt
if ! grep -q "add_subdirectory(CGpass)" $PassDir/CMakeLists.txt; then
    echo "add_subdirectory(CGpass)" >> $PassDir/CMakeLists.txt
fi

# Build LLVM with the new pass
cd $LLVM_PATH/build || { echo "Failed to change directory to $LLVM_PATH/build"; exit 1; }
make -j4


cd $TargetPath
if [ -f "$LLVM_PATH/build/lib/LLVMCGpass.so" ]; then
    echo "Build Pass CGpass successfully"
    cp "$LLVM_PATH/build/lib/LLVMCGpass.so" ./
else
    echo "Build Pass CGpass failed!!"
fi


