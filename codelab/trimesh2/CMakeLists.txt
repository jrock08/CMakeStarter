cc_binary(codelab_mesh_make
  mesh_make.cc
  third_party/trimesh2/lib:trimesh
  "${OPENGL_LIBRARIES};${GLUT_LIBRARIES}"
  )
#add_dependencies(codelab_mesh_make trimesh2)
