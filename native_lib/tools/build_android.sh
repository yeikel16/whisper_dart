#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
    export NDK_HOST_TAG="darwin-x86_64"
elif [[ "$(uname -s)" == "Linux" ]]; then
    export NDK_HOST_TAG="linux-x86_64"
else
    echo "Unsupported OS."
    exit
fi

NDK=${ANDROID_NDK_HOME:-${ANDROID_NDK_ROOT:-"$ANDROID_SDK_ROOT/ndk"}}
COMPILER_DIR="$NDK/toolchains/llvm/prebuilt/$NDK_HOST_TAG/bin"
export PATH="$COMPILER_DIR:$PATH"

echo "$COMPILER_DIR"

if [ "$1" = "x86" ]; then
  export CMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake
  export ANDROID_ABI=x86
  export ANDROID_PLATFORM=android-21
  export ANDROID_STL=c++_shared
  export CC=$COMPILER_DIR/i686-linux-android21-clang
  export CXX=$COMPILER_DIR/i686-linux-android21-clang++
elif [ "$1" = "x64" ]; then
  export CMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake
  export ANDROID_ABI=x86_64
  export ANDROID_PLATFORM=android-21
  export ANDROID_STL=c++_shared
  export CC=$COMPILER_DIR/x86_64-linux-android21-clang
  export CXX=$COMPILER_DIR/x86_64-linux-android21-clang++
elif [ "$1" = "armv7" ]; then
  export CMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake
  export ANDROID_ABI=armeabi-v7a
  export ANDROID_PLATFORM=android-21
  export ANDROID_STL=c++_shared
  export CC=$COMPILER_DIR/armv7a-linux-androideabi21-clang
  export CXX=$COMPILER_DIR/armv7a-linux-androideabi21-clang++
else
  export CMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake
  export ANDROID_ABI=arm64-v8a
  export ANDROID_PLATFORM=android-21
  export ANDROID_STL=c++_shared
  export CC=$COMPILER_DIR/aarch64-linux-android21-clang
  export CXX=$COMPILER_DIR/aarch64-linux-android21-clang++
fi

mkdir -p build_android_$1
cd build_android_$1
cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE \
  -DANDROID_ABI=$ANDROID_ABI \
  -DANDROID_PLATFORM=$ANDROID_PLATFORM \
  -DANDROID_STL=$ANDROID_STL \
  -DCMAKE_BUILD_TYPE=Release \
  -DWHISPER_BUILD_ANDROID=ON
make -j8
cd ..


if [ "$1" = "x86" ]; then
  mv "build_android_x86/libwhisper.so" "libwhisper_android_x86.so"
elif [ "$1" = "x64" ]; then
  mv "build_android_x64/libwhisper.so" "libwhisper_android_x64.so"
elif [ "$1" = "armv7" ]; then
  mv "build_android_armv7/libwhisper.so" "libwhisper_android_armv7.so"
else
  mv "build_android_arm64/libwhisper.so" "libwhisper_android_arm64.so"
fi
