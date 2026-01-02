include(FetchContent)

# 1. Fetch gRPC (which pulls in Protobuf, Abseil, re2, etc.)
FetchContent_Declare(
  gRPC
  GIT_REPOSITORY https://github.com/grpc/grpc
  GIT_TAG        v1.62.0
)
set(gRPC_BUILD_TESTS OFF)
set(protobuf_BUILD_TESTS OFF)
set(gRPC_INSTALL OFF)
set(protobuf_INSTALL OFF)
set(gRPC_ZLIB_PROVIDER "package") # Use system zlib if available, or fetch
set(gRPC_CARES_PROVIDER "package")
set(gRPC_RE2_PROVIDER "package")
set(gRPC_SSL_PROVIDER "package")
set(gRPC_PROTOBUF_PROVIDER "module") # Force module mode to build protobuf from source

FetchContent_MakeAvailable(gRPC)

# 2. Define executables/libraries for generation
# Since we are building from source, targets like `libprotobuf`, `grpc++`, `protoc` should be available.

set(_PROTOBUF_LIBPROTOBUF libprotobuf)
set(_REFLECTION_GRPC_REFLECTION grpc++_reflection)
set(_GRPC_GRPCPP grpc++)

if(TARGET protoc)
  set(_PROTOBUF_PROTOC $<TARGET_FILE:protoc>)
else()
  # Fallback or find_program if protoc target isn't exposed (it usually is)
  set(_PROTOBUF_PROTOC "protoc")
endif()

if(TARGET grpc_cpp_plugin)
  set(_GRPC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:grpc_cpp_plugin>)
else()
  set(_GRPC_CPP_PLUGIN_EXECUTABLE "grpc_cpp_plugin")
endif()

# Define the .proto file path
set(protos "${CMAKE_CURRENT_LIST_DIR}/clue.proto")

# Generate sources
get_filename_component(proto_name "${protos}" NAME_WE)
set(proto_srcs "${CMAKE_CURRENT_BINARY_DIR}/${proto_name}.pb.cc")
set(proto_hdrs "${CMAKE_CURRENT_BINARY_DIR}/${proto_name}.pb.h")
set(grpc_srcs "${CMAKE_CURRENT_BINARY_DIR}/${proto_name}.grpc.pb.cc")
set(grpc_hdrs "${CMAKE_CURRENT_BINARY_DIR}/${proto_name}.grpc.pb.h")

add_custom_command(
  OUTPUT "${proto_srcs}" "${proto_hdrs}" "${grpc_srcs}" "${grpc_hdrs}"
  COMMAND ${_PROTOBUF_PROTOC}
  ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}"
       --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
       -I "${CMAKE_CURRENT_LIST_DIR}"
       --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
       "${protos}"
  DEPENDS "${protos}"
  COMMENT "Generating gRPC/Protobuf sources for ${proto_name}"
)

# Create the library
add_library(clue_messages "${proto_srcs}" "${proto_hdrs}" "${grpc_srcs}" "${grpc_hdrs}")

target_link_libraries(clue_messages
  PUBLIC
    ${_REFLECTION_GRPC_REFLECTION}
    ${_GRPC_GRPCPP}
    ${_PROTOBUF_LIBPROTOBUF}
)

target_include_directories(clue_messages
  PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>"
)
