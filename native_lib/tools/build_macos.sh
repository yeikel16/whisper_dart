#!/bin/bash

mkdir -p build_macos
cd build_macos
cmake .. \
  -GXcode \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_MACOS=ON
cmake --build . --config Release --target whisper -- -quiet
cd ..

mkdir -p build_macos_framework
cd build_macos_framework
cmake .. \
  -GXcode \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_MACOS=ON \
  -DWHISPER_BUILD_MACOS_FRAMEWORK=ON
cmake --build . --config Release --target whisper_framework -- -quiet
cd ..
