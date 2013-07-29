cmake_minimum_required(VERSION 2.8)
enable_testing()

find_package(Protobuf REQUIRED)
message("protobuf include: ${PROTOBUF_INCLUDE_DIRS}")
include_directories(${PROTOBUF_INCLUDE_DIRS})

include_directories(BEFORE FALSE ${CMAKE_SOURCE_DIR})
message("build: ${CMAKE_BINARY_DIR}")
include_directories(BEFORE FALSE ${CMAKE_BINARY_DIR})

add_subdirectory(third_party)
add_subdirectory(codelab)
