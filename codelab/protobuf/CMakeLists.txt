PROTOBUF_GENERATE_CPP(SIMPLE_SRCS SIMPLE_HDRS simple.proto)

cc_binary(codelab_protobuf
  "main.cc;${SIMPLE_SRCS}"
  ""
  "${PROTOBUF_LIBRARIES}"
  )
