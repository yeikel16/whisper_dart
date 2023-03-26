export IPHONEOS_DEPLOYMENT_TARGET=11.0

# Create a build directory and navigate to it
mkdir -p build_ios
cd build_ios

# Configure CMake with the desired architecture and deployment target
cmake .. -GXcode \
  -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake \
  -DPLATFORM=OS64 \
  -DENABLE_BITCODE=FALSE \
  -DIPHONEOS_DEPLOYMENT_TARGET=${IPHONEOS_DEPLOYMENT_TARGET}

# Build the Xcode project
xcodebuild -project Whisper.xcodeproj -configuration Release -scheme Whisper -destination 'generic/platform=iOS' build

# Create the xcframework
xcodebuild -create-xcframework \
  -library build/Release-iphoneos/libWhisper.a \
  -library build/Release-iphonesimulator/libWhisper.a \
  -output Whisper.xcframework

# Zip the xcframework
zip -r whisper_ios.xcframework.zip Whisper.xcframework
