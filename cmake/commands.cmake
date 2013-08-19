
# Takes a path/to/lib:name and outputs a full path to the library and lib name.
function(simple_lib_to_cmake_lib LIB_STRING RETURN_NAME_DIR RETURN_NAME_LIB)
  LOGINFO("lib string: ${LIB_STRING}")
  string(REGEX MATCHALL "([^:]+)" LIB_LIST "${LIB_STRING}")
  LOGINFO("lib list: ${LIB_LIST}")
  list(GET LIB_LIST 0 LIB_DIR)
  list(GET LIB_LIST 1 LIB_NAME)
  LOGINFO("${CMAKE_BINARY_DIR}/${LIB_DIR} || ${LIB_NAME}")
  set(${RETURN_NAME_DIR} ${CMAKE_BINARY_DIR}/${LIB_DIR} PARENT_SCOPE)
  set(${RETURN_NAME_LIB} ${LIB_NAME} PARENT_SCOPE)
endfunction(simple_lib_to_cmake_lib)

# Takes path/to/lib:name and turns it into path_to_lib_name.
function(simple_lib_to_dependency LIB_STRING RETURN_DEPENDENCY)
  string(REGEX REPLACE "[/:]" "_" LIB_REPLACED ${LIB_STRING})
  LOGINFO("libstring: ${LIB_STRING}\n"
          "replaced : ${LIB_REPLACED}")
        set(${RETURN_DEPENDENCY} "${LIB_REPLACED}" PARENT_SCOPE)
endfunction(simple_lib_to_dependency)

# Takes a target (in cmake form) and libraries (in "simple" path/to/lib:name form)
# and links them.
macro(cc_link target simple_libs)
  foreach(lib ${simple_libs})
    simple_lib_to_cmake_lib(${lib} cmake_lib_dir cmake_lib_name)
    simple_lib_to_dependency(${lib} cmake_lib_dependency)
    LOGWARNING("add_dependencies(${target} ${cmake_lib_dependency})")
    add_dependencies("${target}" "${cmake_lib_dependency}")
    LOGWARNING("target_link_libraries(\"${target}\" \"${cmake_lib_dir}/${CMAKE_STATIC_LIBRARY_PREFIX}${cmake_lib_name}${CMAKE_STATIC_LIBRARY_SUFFIX}\")")
    target_link_libraries("${target}" "${cmake_lib_dir}/${CMAKE_STATIC_LIBRARY_PREFIX}${cmake_lib_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")
  endforeach(lib ${simple_libs})
endmacro(cc_link)

# Takes a target in cmake form and creates the dependency that simple libs need to exist.
macro(cc_link_self target)
  simple_lib_to_dependency("${CMAKE_CURRENT_SOURCE_DIR}:${target}" cmake_lib_dependency)
  LOGWARNING("add_dependency(\"${cmake_lib_dependency}\" \"${target}\")")
  add_dependency("${cmake_lib_dependency}" "${target}")
endmacro(cc_link_self)

macro(add_simple_lib_dependencies simple_lib cmake_target)
  simple_lib_to_dependency(${simple_lib} cmake_lib_dependency)
  #LOGWARNING("add_dependencies(\"${cmake_target}\" \"${cmake_lib_dependency}\")")
  #add_dependencies("${cmake_target}" "${cmake_lib_dependency}")
  LOGWARNING("add_dependencies(\"${cmake_lib_dependency}\" \"${cmake_target}\")")
  add_custom_target("${cmake_lib_dependency}")
  add_dependencies("${cmake_lib_dependency}" "${cmake_target}")
endmacro(add_simple_lib_dependencies)


macro(cc_test TEST_NAME SOURCES LIBS OTHERLIBS)
  cc_binary("${TEST_NAME}" "${SOURCES}" "${LIBS}" "${OTHERLIBS}")
  set(TESTLIBS "gtest;gtest_main")
  target_link_libraries("${TEST_NAME}" ${TESTLIBS})
  add_test("${TEST_NAME}" "${TEST_NAME}")
endmacro(cc_test)

macro(cc_binary BINARY_NAME SOURCES LIBS OTHERLIBS)
  LOGINFO("BINARY_NAME ${BINARY_NAME}")
  LOGINFO("SOURCES ${SOURCES}")
  LOGINFO("LIBS ${LIBS}")
  LOGINFO("OTHERLIBS ${OTHERLIBS}")

  LOGWARNING("add_executable(${BINARY_NAME} ${SOURCES})")
  add_executable("${BINARY_NAME}" ${SOURCES})
  cc_link("${BINARY_NAME}" "${LIBS}")
  LOGWARNING("target_link_libraries(${BINARY_NAME} ${OTHERLIBS})")
  target_link_libraries(${BINARY_NAME} ${OTHERLIBS})
endmacro(cc_binary)

macro(cc_library LIB_NAME SOURCES LIBS OTHERLIBS)
  LOGINFO("LIBRARY_NAME ${LIB_NAME}")
  LOGINFO("SOURCES ${SOURCES}")
  LOGINFO("LIBS ${LIBS}")
  LOGINFO("OTHERLIBS ${OTHERLIBS}")

  add_library(${LIB_NAME} ${SOURCES})
  cc_link(${LIB_NAME} ${LIBS})
  cc_link_self(${LIB_NAME})
  target_link_libraries(${cc_library} ${OTHERLIBS})
endmacro(cc_library)
