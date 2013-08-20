
# Takes a path/to/lib:name and outputs a full path to the library and lib name:
# path/to/lib/libname.a
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

# Takes the name portion of path/to/lib:name, and assumes the current working
# directory for the path/to/lib.  Outputs the path_to_lib_name which can be
# used as a unique identifier for the library or executable
function(simple_name_to_full_name SIMPLE_NAME RETURN_DEPENDENCY)
  string(REPLACE "${CMAKE_SOURCE_DIR}/" "" RELATIVE_SOURCE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
  simple_lib_to_dependency("${RELATIVE_SOURCE_PATH}:${SIMPLE_NAME}" full_name)
  set(${RETURN_DEPENDENCY} "${full_name}" PARENT_SCOPE)
endfunction(simple_name_to_full_name)

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
    #simple_lib_to_cmake_lib(${lib} cmake_lib_dir cmake_lib_name)
    simple_lib_to_dependency(${lib} full_lib_target)
    target_link_libraries(${target} ${full_lib_target})
    #LOGWARNING("add_dependencies(${target} ${cmake_lib_dependency})")
    #add_dependencies("${target}" "${cmake_lib_dependency}")
    #LOGWARNING("target_link_libraries(\"${target}\" \"${cmake_lib_dir}/${CMAKE_STATIC_LIBRARY_PREFIX}${cmake_lib_name}${CMAKE_STATIC_LIBRARY_SUFFIX}\")")
    #target_link_libraries("${target}" "${cmake_lib_dir}/${CMAKE_STATIC_LIBRARY_PREFIX}${cmake_lib_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")
  endforeach(lib ${simple_libs})
endmacro(cc_link)

# Takes a target in cmake form and creates the dependency that simple libs need to exist.
macro(cc_link_self target)
  LOGWARNING("REPLACE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_SOURCE_DIR} \"\" relative_source_path")
  string(REPLACE "${CMAKE_SOURCE_DIR}/" "" relative_source_path "${CMAKE_CURRENT_SOURCE_DIR}")
  LOGWARNING("relative_source_path: ${relative_source_path}")
  simple_lib_to_dependency("${relative_source_path}:${target}" cmake_lib_dependency)
  LOGWARNING("add_dependency(\"${cmake_lib_dependency}\" \"${target}\")")
  add_dependencies("${cmake_lib_dependency}" "${target}")
endmacro(cc_link_self)

macro(import_simple_lib simple_lib generating_target)
  simple_lib_to_dependency(${simple_lib} full_lib_target)
  add_library(${full_lib_target} STATIC IMPORTED GLOBAL)
  simple_lib_to_cmake_lib(${simple_lib} lib_dir lib_name)
  set_property(TARGET ${full_lib_target}
    PROPERTY IMPORTED_LOCATION
    "${lib_dir}/${CMAKE_STATIC_LIBRARY_PREFIX}${lib_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")
  add_dependencies("${full_lib_target}" "${generating_target}")
endmacro(import_simple_lib)

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
  simple_name_to_full_name(${TEST_NAME} full_binary_target)
  target_link_libraries("${full_binary_target}" ${TESTLIBS})
  add_test("${TEST_NAME}" "${CMAKE_CURRENT_BUILD_DIR}/${TEST_NAME}")
endmacro(cc_test)

macro(cc_binary BINARY_NAME SOURCES LIBS OTHERLIBS)
  simple_name_to_full_name(${BINARY_NAME} full_binary_target)
  LOGINFO("BINARY_NAME ${full_binary_target}")
  LOGINFO("SOURCES ${SOURCES}")
  LOGINFO("LIBS ${LIBS}")
  LOGINFO("OTHERLIBS ${OTHERLIBS}")

  LOGWARNING("add_executable(${full_binary_target} ${SOURCES})")
  add_executable("${full_binary_target}" ${SOURCES})
  cc_link("${full_binary_target}" "${LIBS}")
  LOGWARNING("target_link_libraries(${full_binary_target} ${OTHERLIBS})")
  target_link_libraries(${full_binary_target} ${OTHERLIBS})
  set_target_properties("${full_binary_target}"
    PROPERTIES OUTPUT_NAME "${BINARY_NAME}")
endmacro(cc_binary)

macro(cc_library LIB_NAME SOURCES LIBS OTHERLIBS)
  simple_name_to_full_name(${LIB_NAME} full_lib_target)
  LOGINFO("LIBRARY_NAME ${full_lib_target}")
  LOGINFO("SOURCES ${SOURCES}")
  LOGINFO("LIBS ${LIBS}")
  LOGINFO("OTHERLIBS ${OTHERLIBS}")

  add_library(${full_lib_target} ${SOURCES})
  cc_link("${full_lib_target}" "${LIBS}")
  if(OTHERLIBS)
    target_link_libraries("${cc_library}" "${OTHERLIBS}")
  endif(OTHERLIBS)
  set_target_properties("${full_lib_target}"
    PROPERTIES OUTPUT_NAME "${LIB_NAME}")
endmacro(cc_library)

macro(cc_protobuf TARGET_NAME PROTO_FILE)
  PROTOBUF_GENERATE_CPP(PROTO_SOURCES PROTO_HDRS ${PROTO_FILE})
  simple_name_to_full_name(${TARGET_NAME} full_lib_name)
  add_library("${full_lib_name}" "${PROTO_SOURCES}")
  message("${PROTOBUF_LIBRARIES}")
  target_link_libraries("${full_lib_name}" ${PROTOBUF_LIBRARIES})
endmacro(cc_protobuf)

