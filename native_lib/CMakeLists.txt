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

if(APPLE)
  target_compile_options(whisper PRIVATE -stdlib=libc++)
  target_link_libraries(whisper PRIVATE "-framework Foundation" "-framework CoreFoundation" "-framework Security")
  if(IOS)
    set_target_properties(whisper PROPERTIES
      XCODE_ATTRIBUTE_ENABLE_BITCODE "NO"
      XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "11.0"
    )
  elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set_target_properties(whisper PROPERTIES
      MACOSX_RPATH ON
      MACOSX_BUNDLE TRUE
      MACOSX_FRAMEWORK_IDENTIFIER "com.example.whisper"
      MACOSX_DEPLOYMENT_TARGET "11.0"
    )
  endif()
endif()
