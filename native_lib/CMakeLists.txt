cmake_minimum_required(VERSION 3.10)

project(whisper_library VERSION 0.0.1 LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 20)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")

add_library(whisper SHARED main.cpp)
add_library(whisper_lib whisper.cpp/whisper.cpp)
add_library(ggml whisper.cpp/ggml.c)

set_target_properties(whisper PROPERTIES
  PUBLIC_HEADER whisper.cpp/whisper.h 
  OUTPUT_NAME "whisper"
)

if (WIN32)
set_target_properties(whisper PROPERTIES
  WINDOWS_EXPORT_ALL_SYMBOLS ON
)
endif (WIN32)

target_compile_definitions(whisper PUBLIC DART_SHARED_LIB)
target_link_libraries(whisper PRIVATE whisper_lib ggml ${CMAKE_THREAD_LIBS_INIT})

if(IOS_PLATFORM)
set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "Minimum OS X deployment version")
set(IOS_DEPLOYMENT_TARGET "11.0" CACHE STRING "Minimum iOS deployment version")


set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_VERSION ${IOS_DEPLOYMENT_TARGET})

set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64")

set(CMAKE_C_COMPILER "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang")
set(CMAKE_CXX_COMPILER "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++")

set(IOS_SDK_ROOT "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk")

set(CMAKE_CXX_FLAGS "-fembed-bitcode -stdlib=libc++ -std=c++14 -Wall")

add_library(whisper STATIC whisper.cpp)

include_directories("${IOS_SDK_ROOT}/usr/include")
link_directories("${IOS_SDK_ROOT}/usr/lib")

target_link_libraries(whisper "-framework Foundation" "-framework CoreFoundation" "-framework CoreAudio" "-framework AudioToolbox" "-framework AVFoundation" "-framework Accelerate" "-framework Security")

endif()
