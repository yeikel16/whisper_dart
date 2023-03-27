export IPHONEOS_DEPLOYMENT_TARGET=11.0

# Create build directories
rm -rf build_ios_aarch64
mkdir build_ios_aarch64
cd build_ios_aarch64

# Configure CMake for aarch64-apple-ios
cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=../ios-cmake/toolchain/iOS.cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_IOS=ON \
  -DIOS_ARCH=arm64 \
  -DIOS_PLATFORM=OS \
  -DCMAKE_OSX_SYSROOT=iphoneos \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=$IPHONEOS_DEPLOYMENT_TARGET

# Build for aarch64-apple-ios
cmake --build . --config Release

# Create build directories
cd ..
rm -rf build_ios_aarch64_sim
mkdir build_ios_aarch64_sim
cd build_ios_aarch64_sim

# Configure CMake for aarch64-apple-ios-simulator
cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=../ios-cmake/toolchain/iOS.cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_IOS=ON \
  -DIOS_ARCH=arm64 \
  -DIOS_PLATFORM=SIMULATOR \
  -DCMAKE_OSX_SYSROOT=iphonesimulator \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=$IPHONEOS_DEPLOYMENT_TARGET

# Build for aarch64-apple-ios-simulator
cmake --build . --config Release

# Create build directories
cd ..
rm -rf build_ios_x86_64
mkdir build_ios_x86_64
cd build_ios_x86_64

# Configure CMake for x86_64-apple-ios
cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=../ios-cmake/toolchain/iOS.cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_IOS=ON \
  -DIOS_ARCH=x86_64 \
  -DIOS_PLATFORM=OS \
  -DCMAKE_OSX_SYSROOT=iphoneos \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=$IPHONEOS_DEPLOYMENT_TARGET

# Build for x86_64-apple-ios
cmake --build . --config Release

# Create xcframework
cd ..
rm -rf whisper.xcframework
xcodebuild -create-xcframework \
  -library build_ios_aarch64/Release-iphoneos/libwhisper.a \
  -library build_ios_aarch64_sim/Release-iphonesimulator/libwhisper.a \
  -library build_ios_x86_64/Release-iphoneos/libwhisper.a \
  -output whisper.xcframework

# Zip xcframework
zip -r whisper_ios.xcframework.zip whisper.xcframework
