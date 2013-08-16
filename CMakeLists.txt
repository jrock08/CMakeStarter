cmake_minimum_required(VERSION 2.8)
enable_testing()
include(cmake/logging.cmake)
include(cmake/commands.cmake)

find_package(Threads)

find_package(Protobuf REQUIRED)
include_directories(${PROTOBUF_INCLUDE_DIRS})

find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)

include_directories(BEFORE FALSE ${CMAKE_SOURCE_DIR})
include_directories(BEFORE FALSE ${CMAKE_BINARY_DIR})

add_subdirectory(third_party)

add_subdirectory(codelab)
