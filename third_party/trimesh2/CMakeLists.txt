project(trimesh2 CXX C)
cmake_minimum_required(VERSION 2.6.2)

find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)

if (__APPLE__)
  add_definitions(-DDARWIN)
endif(__APPLE__)

message("trimesh2: ${trimesh2_SOURCE_DIR}")
set(trimesh2_INCLUDES
  ${trimesh2_SOURCE_DIR}/include/GL
  ${trimesh2_SOURCE_DIR}/include
  ${trimesh2_SOURCE_DIR}
  )

message("trimesh2_INCLUDES: ${trimesh2_INCLUDES}")

include_directories(${trimesh2_INCLUDES})

add_subdirectory(lib)
add_subdirectory(gluit)
add_subdirectory(util)
