add_subdirectory(gtest-1.6.0)
add_subdirectory(trimesh2)
set(third_party_INCLUDES ${trimesh2_INCLUDES} PARENT_SCOPE)
