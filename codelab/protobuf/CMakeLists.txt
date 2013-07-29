protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS test.proto)
message("srcs: ${PROTO_SRCS}")
message("hdrs: ${PROTO_HDRS}")

add_executable(proto_codelab main.cc "${PROTO_SRCS}")
target_link_libraries(proto_codelab ${PROTOBUF_LIBRARY})
