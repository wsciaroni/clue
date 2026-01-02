
set(PROTO_FILE clue_service.proto)

# We rely on targets from FetchContent in root CMakeLists.txt

if(TARGET gRPC::grpc_cpp_plugin)
    set(grpc_plugin_target gRPC::grpc_cpp_plugin)
else()
    set(grpc_plugin_target grpc_cpp_plugin)
endif()

if(TARGET protobuf::protoc)
    set(protoc_target protobuf::protoc)
else()
    if(TARGET protoc)
        set(protoc_target protoc)
    else()
        message(FATAL_ERROR "protoc target not found")
    endif()
endif()

set(protoc_binary $<TARGET_FILE:${protoc_target}>)
set(grpc_cpp_plugin_binary $<TARGET_FILE:${grpc_plugin_target}>)

set(PROTO_HDRS "${CMAKE_CURRENT_BINARY_DIR}/clue_service.pb.h" "${CMAKE_CURRENT_BINARY_DIR}/clue_service.grpc.pb.h")
set(PROTO_SRCS "${CMAKE_CURRENT_BINARY_DIR}/clue_service.pb.cc" "${CMAKE_CURRENT_BINARY_DIR}/clue_service.grpc.pb.cc")

add_custom_command(
    OUTPUT ${PROTO_HDRS} ${PROTO_SRCS}
    COMMAND ${protoc_binary}
    ARGS --grpc_out=${CMAKE_CURRENT_BINARY_DIR}
         --cpp_out=${CMAKE_CURRENT_BINARY_DIR}
         --plugin=protoc-gen-grpc=${grpc_cpp_plugin_binary}
         -I ${CMAKE_CURRENT_SOURCE_DIR}
         ${CMAKE_CURRENT_SOURCE_DIR}/${PROTO_FILE}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${PROTO_FILE} ${grpc_plugin_target} ${protoc_target}
)

add_library(clue_messages ${PROTO_SRCS} ${PROTO_HDRS})

if(TARGET gRPC::grpc++)
    set(grpc_target gRPC::grpc++)
else()
    set(grpc_target grpc++)
endif()

if(TARGET protobuf::libprotobuf)
    set(protobuf_target protobuf::libprotobuf)
else()
    set(protobuf_target libprotobuf)
endif()


target_link_libraries(clue_messages
    PUBLIC
        ${grpc_target}
        ${protobuf_target}
)

target_include_directories(clue_messages
    PUBLIC
        ${CMAKE_CURRENT_BINARY_DIR}
)
