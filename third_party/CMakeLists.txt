include(ExternalProject)
externalproject_add(trimesh2
  SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/trimesh2"
  BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/trimesh2"
  INSTALL_COMMAND ""
  )
add_simple_lib_dependencies(third_party/trimesh2/lib:trimesh trimesh2)


#list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/trimesh2")
