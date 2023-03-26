#!/bin/bash

if ! command -v ios-cmake &> /dev/null
then
    echo "ios-cmake not found. Installing..."
    brew install ios-cmake
fi


mkdir -p build_ios
cd build_ios
cmake .. \
  -GXcode \
  -DCMAKE_TOOLCHAIN_FILE="$HOME/ios-cmake/toolchain/iOS.cmake" \
  -DIOS_PLATFORM=OS \
  -DENABLE_ARC=1 \
  -DENABLE_BITCODE=0 \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_IOS=ON
cmake --build . --config Release --target whisper -- -quiet
cd ..

mkdir -p build_ios_framework
cd build_ios_framework
cmake .. \
  -GXcode \
  -DCMAKE_TOOLCHAIN_FILE="$HOME/ios-cmake/toolchain/iOS.cmake" \
  -DIOS_PLATFORM=OS \
  -DENABLE_ARC=1 \
  -DENABLE_BITCODE=0 \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_IOS=ON \
  -DWHISPER_BUILD_IOS_FRAMEWORK=ON
cmake --build . --config Release --target whisper_framework -- -quiet
cd ..
