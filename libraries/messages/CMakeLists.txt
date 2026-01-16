include(FetchContent)

# 1. Fetch gRPC (which pulls in Protobuf, Abseil, re2, etc.)
FetchContent_Declare(
  gRPC
  GIT_REPOSITORY https://github.com/grpc/grpc
  GIT_TAG        v1.75.0
)

# --- START: SILENCE GRPC & DEPENDENCY TESTS ---

# 1. Save your current testing state
set(PAST_BUILD_TESTING ${BUILD_TESTING})

# 2. Force turn off testing globally for these deps
set(BUILD_TESTING OFF CACHE BOOL "Disable tests globally for deps" FORCE)

# 3. Explicitly disable gRPC and Protobuf tests
set(gRPC_BUILD_TESTS OFF CACHE BOOL "Disable gRPC tests" FORCE)
set(protobuf_BUILD_TESTS OFF CACHE BOOL "Disable Protobuf tests" FORCE)
set(protobuf_BUILD_EXAMPLES OFF CACHE BOOL "Disable Protobuf examples" FORCE)

# 4. Explicitly disable Abseil (absl) tests - The heavy hitter
set(ABSL_BUILD_TESTING OFF CACHE BOOL "Disable Abseil tests" FORCE)
set(ABSL_USE_GOOGLETEST_HEAD OFF CACHE BOOL "Disable Abseil using GTest" FORCE)

# 5. Disable Benchmark and Re2 tests (often pulled in by gRPC)
set(BENCHMARK_ENABLE_TESTING OFF CACHE BOOL "Disable Benchmark tests" FORCE)
set(RE2_BUILD_TESTING OFF CACHE BOOL "Disable Re2 tests" FORCE)

# --- END: SILENCE GRPC & DEPENDENCY TESTS ---

set(gRPC_BUILD_TESTS OFF)
set(protobuf_BUILD_TESTS OFF)
set(gRPC_INSTALL OFF)
set(protobuf_INSTALL OFF)
set(gRPC_ZLIB_PROVIDER "module")
set(gRPC_CARES_PROVIDER "module")
set(gRPC_RE2_PROVIDER "module")
set(gRPC_SSL_PROVIDER "module")
set(gRPC_PROTOBUF_PROVIDER "module")

FetchContent_MakeAvailable(gRPC)

# 6. Restore your project's testing state so YOUR tests still build
set(BUILD_TESTING ${PAST_BUILD_TESTING} CACHE BOOL "Restore testing" FORCE)

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

# -------------------------------------------------------------------------
# Dart generation for frontend
# -------------------------------------------------------------------------
find_program(DART_PROTOC_PLUGIN protoc-gen-dart HINTS "$ENV{HOME}/.pub-cache/bin")

if(DART_PROTOC_PLUGIN)
  get_filename_component(FRONTEND_GEN_DIR "${CMAKE_CURRENT_LIST_DIR}/../../applications/frontend/lib/generated" ABSOLUTE)
  file(MAKE_DIRECTORY ${FRONTEND_GEN_DIR})

  set(dart_srcs
    "${FRONTEND_GEN_DIR}/${proto_name}.pb.dart"
    "${FRONTEND_GEN_DIR}/${proto_name}.pbenum.dart"
    "${FRONTEND_GEN_DIR}/${proto_name}.pbgrpc.dart"
    "${FRONTEND_GEN_DIR}/${proto_name}.pbjson.dart"
  )

  add_custom_command(
    OUTPUT ${dart_srcs}
    COMMAND ${_PROTOBUF_PROTOC}
    ARGS --dart_out=grpc:${FRONTEND_GEN_DIR}
         -I "${CMAKE_CURRENT_LIST_DIR}"
         --plugin=protoc-gen-dart=${DART_PROTOC_PLUGIN}
         "${protos}"
    DEPENDS "${protos}"
    COMMENT "Generating Dart gRPC/Protobuf sources for ${proto_name}"
  )

  # Create a target so that it runs when building
  add_custom_target(generate_dart_protos ALL DEPENDS ${dart_srcs})
else()
  message(WARNING "protoc-gen-dart not found. Dart generation skipped. Install it with: dart pub global activate protoc_plugin")
endif()

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

# Install configuration (necessary for export)
# include(GNUInstallDirs)
# install(TARGETS clue_messages
#         EXPORT clue_messagesTargets
#         LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#         ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
#         RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#         INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
# )

# install(EXPORT clue_messagesTargets
#         FILE clue_messagesTargets.cmake
#         NAMESPACE clue_messages::
#         DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/clue_messages
# )
