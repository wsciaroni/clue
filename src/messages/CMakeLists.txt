# Setup Protobuf and gRPC
include(FetchContent)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Disable installation of dependencies to avoid export set errors
set(gRPC_INSTALL OFF CACHE BOOL "" FORCE)
set(protobuf_INSTALL OFF CACHE BOOL "" FORCE)
set(absl_INSTALL OFF CACHE BOOL "" FORCE)
set(ABSL_ENABLE_INSTALL OFF CACHE BOOL "" FORCE)
set(utf8_range_ENABLE_INSTALL OFF CACHE BOOL "" FORCE)
set(utf8_range_INSTALL OFF CACHE BOOL "" FORCE)

# Configuration for gRPC/Protobuf
set(gRPC_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(protobuf_BUILD_TESTS OFF CACHE BOOL "" FORCE)

set(gRPC_BUILD_CSHARP_EXT OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_CSHARP_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_NODE_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_PHP_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_PYTHON_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_RUBY_PLUGIN OFF CACHE BOOL "" FORCE)

set(ABSL_PROPAGATE_CXX_STD ON CACHE BOOL "" FORCE)
set(ABSL_ENABLE_GOOGLETEST OFF CACHE BOOL "" FORCE)

# Fix for "Package 'libsystemd' not found"
set(gRPC_USE_PROTO_LITE OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
  gRPC
  GIT_REPOSITORY https://github.com/grpc/grpc
  GIT_TAG        v1.54.2
)
FetchContent_MakeAvailable(gRPC)

# Since we are building gRPC/Protobuf from source, we don't use find_package(Protobuf).
# Instead we use the targets defined by the project.

set(PROTO_FILES clue.proto)

# Generate C++ sources
set(PROTO_SRCS)
set(PROTO_HDRS)
set(GRPC_SRCS)
set(GRPC_HDRS)

if(TARGET protoc)
    set(Protobuf_PROTOC_EXECUTABLE $<TARGET_FILE:protoc>)
else()
    # Fallback or error
    message(WARNING "protoc target not found, this might fail")
    set(Protobuf_PROTOC_EXECUTABLE protoc)
endif()


if(TARGET grpc_cpp_plugin)
    set(GRPC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:grpc_cpp_plugin>)
else()
     message(WARNING "grpc_cpp_plugin target not found")
     set(GRPC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)
endif()

# We need to manually generate because protobuf_generate_cpp might rely on FindProtobuf variables
add_custom_command(
      OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/clue.pb.cc"
             "${CMAKE_CURRENT_BINARY_DIR}/clue.pb.h"
      COMMAND ${Protobuf_PROTOC_EXECUTABLE}
      ARGS --cpp_out="${CMAKE_CURRENT_BINARY_DIR}"
           -I "${CMAKE_CURRENT_SOURCE_DIR}"
           "${CMAKE_CURRENT_SOURCE_DIR}/clue.proto"
      DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/clue.proto" ${Protobuf_PROTOC_EXECUTABLE}
)

add_custom_command(
      OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/clue.grpc.pb.cc"
             "${CMAKE_CURRENT_BINARY_DIR}/clue.grpc.pb.h"
      COMMAND ${Protobuf_PROTOC_EXECUTABLE}
      ARGS --grpc_out="${CMAKE_CURRENT_BINARY_DIR}"
           -I "${CMAKE_CURRENT_SOURCE_DIR}"
           --plugin=protoc-gen-grpc="${GRPC_CPP_PLUGIN_EXECUTABLE}"
           "${CMAKE_CURRENT_SOURCE_DIR}/clue.proto"
      DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/clue.proto" ${Protobuf_PROTOC_EXECUTABLE} ${GRPC_CPP_PLUGIN_EXECUTABLE}
)

set(PROTO_SRCS "${CMAKE_CURRENT_BINARY_DIR}/clue.pb.cc")
set(PROTO_HDRS "${CMAKE_CURRENT_BINARY_DIR}/clue.pb.h")
set(GRPC_SRCS "${CMAKE_CURRENT_BINARY_DIR}/clue.grpc.pb.cc")
set(GRPC_HDRS "${CMAKE_CURRENT_BINARY_DIR}/clue.grpc.pb.h")

add_library(messages_lib ${PROTO_SRCS} ${PROTO_HDRS} ${GRPC_SRCS} ${GRPC_HDRS})

# Link against the targets provided by the fetched projects
target_link_libraries(messages_lib
    PUBLIC
    libprotobuf
    grpc++
)

target_include_directories(messages_lib PUBLIC "${CMAKE_CURRENT_BINARY_DIR}")
