add_executable(codelab_mesh_make mesh_make.cc)

target_link_libraries(codelab_mesh_make trimesh ${OPENGL_LIBRARIES} ${GLUT_LIBRARIES})
