cc_library(cc_test_obj_lib
  "cmake_test_obj.cc"
  ""
  "")

cc_binary(cc_test
  "main.cc"
  "cmake_test:cc_test_obj_lib"
  "")
