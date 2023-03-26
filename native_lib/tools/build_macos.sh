export MACOSX_DEPLOYMENT_TARGET=11

# Create build directory
mkdir build_macos && cd build_macos

# Generate CMake files
cmake -DCMAKE_BUILD_TYPE=Release ..

# Build for aarch64 and x86_64 architectures
cmake --build . --config Release --target wisper_aarch64
cmake --build . --config Release --target wisper_x86_64

# Combine the resulting libraries into a universal binary
lipo "wisper_aarch64/libwisper.dylib" "wisper_x86_64/libwisper.dylib" -output "libwisper_macos.dylib" -create
