# AddCommonLibraryDirectory
#
# This function automates the creation of a C++ library, including its mocks, unit tests,
# and installation rules, based on a standard directory structure.
#
# Directory Structure:
#   include/  - Public headers (exposed to consumers)
#   source/   - Private sources and headers (implementation details)
#   mocks/    - Mock implementation (using GoogleMock)
#   tests/    - Unit tests (using GoogleTest)
#
# Arguments:
#   LIB_NAME                : The name of the library target to create.
#   PUBLIC_DEPENDENCIES     : List of public dependencies (propagated to consumers).
#   INTERFACE_DEPENDENCIES  : List of interface dependencies (propagated but not linked if header-only).
#   PRIVATE_DEPENDENCIES    : List of private dependencies (implementation details only).
#   MOCK_DEPENDENCIES       : List of dependencies specific to the mock library.
#   NO_WARN_AS_ERROR        : Option to disable "warnings as errors" (default is ON).
#   USE_CTEST_ONLY          : Option to force using simple `add_test` instead of `gtest_discover_tests`.
#
# Generated Targets:
#   <LIB_NAME>              : The main library (STATIC or INTERFACE).
#   <LIB_NAME>_mocks        : The mock library (STATIC), if `mocks/` exists.
#   <LIB_NAME>_unittests    : The test executable, if `tests/` exists.
#
# Example Usage:
#   AddCommonLibraryDirectory(
#       LIB_NAME myLib
#       PUBLIC_DEPENDENCIES otherLib
#   )
#

# Helper function for common configuration
function(common_library_configure_target TARGET_NAME NO_WARN_AS_ERROR)
    # Warnings
    if(NOT NO_WARN_AS_ERROR)
        if(MSVC)
            target_compile_options(${TARGET_NAME} PRIVATE /WX)
        else()
            target_compile_options(${TARGET_NAME} PRIVATE -Werror)
        endif()
    endif()

    # Standard C++ configuration could go here if not global
endfunction()

function(AddCommonLibraryDirectory)
    set(options NO_WARN_AS_ERROR USE_CTEST_ONLY)
    set(oneValueArgs LIB_NAME)
    set(multiValueArgs PUBLIC_DEPENDENCIES INTERFACE_DEPENDENCIES PRIVATE_DEPENDENCIES MOCK_DEPENDENCIES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT ARG_LIB_NAME)
        message(FATAL_ERROR "AddCommonLibraryDirectory requires LIB_NAME argument")
    endif()

    # Directory Globbing
    file(GLOB_RECURSE PUBLIC_HEADERS CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp")
    file(GLOB_RECURSE PRIVATE_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/source/*.c" "${CMAKE_CURRENT_SOURCE_DIR}/source/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/source/*.hpp")
    file(GLOB_RECURSE MOCK_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/mocks/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/mocks/*.c" "${CMAKE_CURRENT_SOURCE_DIR}/mocks/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/mocks/*.hpp")
    file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.c" "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.hpp")

    # --- Main Library ---
    if(PRIVATE_SOURCES)
        add_library(${ARG_LIB_NAME} STATIC ${PRIVATE_SOURCES} ${PUBLIC_HEADERS})
        target_include_directories(${ARG_LIB_NAME} PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>" "$<INSTALL_INTERFACE:include>")
        target_include_directories(${ARG_LIB_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/source")

        # Apply common configuration
        common_library_configure_target(${ARG_LIB_NAME} "${ARG_NO_WARN_AS_ERROR}")
    else()
        add_library(${ARG_LIB_NAME} INTERFACE)
        target_include_directories(${ARG_LIB_NAME} INTERFACE "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>" "$<INSTALL_INTERFACE:include>")
    endif()

    # Dependencies
    if(ARG_PUBLIC_DEPENDENCIES)
        target_link_libraries(${ARG_LIB_NAME} PUBLIC ${ARG_PUBLIC_DEPENDENCIES})
    endif()
    if(ARG_INTERFACE_DEPENDENCIES)
        target_link_libraries(${ARG_LIB_NAME} INTERFACE ${ARG_INTERFACE_DEPENDENCIES})
    endif()
    if(ARG_PRIVATE_DEPENDENCIES)
        if(PRIVATE_SOURCES)
            target_link_libraries(${ARG_LIB_NAME} PRIVATE ${ARG_PRIVATE_DEPENDENCIES})
        else()
             message(WARNING "Library ${ARG_LIB_NAME} is INTERFACE (no sources), PRIVATE_DEPENDENCIES ignored.")
        endif()
    endif()

    # Install Configuration
    include(GNUInstallDirs)
    install(TARGETS ${ARG_LIB_NAME}
            EXPORT ${ARG_LIB_NAME}Targets
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
    install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/" DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

    install(EXPORT ${ARG_LIB_NAME}Targets
            FILE ${ARG_LIB_NAME}Targets.cmake
            NAMESPACE ${ARG_LIB_NAME}::
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${ARG_LIB_NAME}
    )

    # --- Mock Library ---
    if(MOCK_SOURCES)
        set(MOCK_LIB_NAME "${ARG_LIB_NAME}_mocks")
        add_library(${MOCK_LIB_NAME} STATIC ${MOCK_SOURCES})
        target_link_libraries(${MOCK_LIB_NAME} PUBLIC ${ARG_LIB_NAME} ${ARG_MOCK_DEPENDENCIES})

        # Updated include directories to handle INSTALL_INTERFACE and install mocks dir
        target_include_directories(${MOCK_LIB_NAME} PUBLIC
            "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/mocks>"
            "$<INSTALL_INTERFACE:include/${ARG_LIB_NAME}/mocks>"
        )

        # Link GMock
        target_link_libraries(${MOCK_LIB_NAME} PUBLIC gmock gtest)

        # Apply common configuration
        common_library_configure_target(${MOCK_LIB_NAME} "${ARG_NO_WARN_AS_ERROR}")

        install(TARGETS ${MOCK_LIB_NAME}
            EXPORT ${ARG_LIB_NAME}Targets
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${ARG_LIB_NAME}/mocks
        )

        # Install mock headers
        install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/mocks/"
                DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${ARG_LIB_NAME}/mocks"
        )
    endif()

    # --- Unit Test Executable ---
    if(TEST_SOURCES)
        set(TEST_EXE_NAME "${ARG_LIB_NAME}_unittests")
        add_executable(${TEST_EXE_NAME} ${TEST_SOURCES})
        target_include_directories(${TEST_EXE_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/tests")

        # Link against lib and GTest/GMock
        target_link_libraries(${TEST_EXE_NAME} PRIVATE ${ARG_LIB_NAME} gtest_main gmock)
        if(TARGET ${ARG_LIB_NAME}_mocks)
             target_link_libraries(${TEST_EXE_NAME} PRIVATE ${ARG_LIB_NAME}_mocks)
        endif()

        # Apply common configuration (tests often want warnings too)
        common_library_configure_target(${TEST_EXE_NAME} "${ARG_NO_WARN_AS_ERROR}")

        # Test Discovery
        if(ARG_USE_CTEST_ONLY OR COMMON_LIB_GLOBAL_USE_CTEST_ONLY)
            add_test(NAME ${TEST_EXE_NAME} COMMAND ${TEST_EXE_NAME})
        else()
            include(GoogleTest)
            gtest_discover_tests(${TEST_EXE_NAME})
        endif()
    endif()

endfunction()
