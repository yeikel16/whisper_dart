#!/bin/bash

set -e

# Install ios-cmake if it's not already installed
if ! command -v ios-cmake &> /dev/null
then
    echo "ios-cmake could not be found. Installing..."
    brew install ios-cmake
fi

# Set up build directories
rm -rf build_ios
mkdir build_ios
cd build_ios

# Configure CMake
cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=../ios-cmake/toolchain/iOS.cmake \
  -DIOS_PLATFORM=OS \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_IOS=ON

# Build the project
cmake --build . --config Release

# Copy the built library to the project directory
cp Release-iphoneos/libwhisper.a ../whisper_library.xcodeproj/libwhisper_ios.a
