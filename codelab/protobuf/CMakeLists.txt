cc_protobuf(simple_proto simple.proto)
 
cc_binary(codelab_protobuf
  "main.cc"
  "codelab/protobuf:simple_proto"
  ""
  )
