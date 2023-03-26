#!/bin/bash

# Navigate to the project directory
cd whisper_library

# Make sure that all of the submodules are up-to-date
git submodule update --init --recursive

# Create a build directory
mkdir -p build/ios
cd build/ios

# Use cmake to generate the Xcode project
cmake ../.. -DCMAKE_TOOLCHAIN_FILE=../../ios-cmake/toolchain/iOS.cmake -DIOS_PLATFORM=SIMULATOR64 -GXcode

# Build the project using xcodebuild
xcodebuild build -project whisper_library.xcodeproj -configuration Release -scheme whisper_library -destination 'platform=iOS'
