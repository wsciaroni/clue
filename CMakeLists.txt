# CMakeList.txt : Top-level CMake project file, do global configuration
# and include sub-projects here.
#
cmake_minimum_required (VERSION 3.25)

project ("clue_game")

# GoogleTest requires at least C++14
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(ENABLE_COVERAGE "Enable code coverage generation" OFF)

if(ENABLE_COVERAGE)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        add_compile_options(--coverage)
        add_link_options(--coverage)
        message(STATUS "Code coverage enabled")
    else()
        message(WARNING "Code coverage enabled but not supported for this compiler")
    endif()
endif()

# To organize projects in VisualStudio:
if(MSVC)
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endif(MSVC)

include(cmake/EnableGTest.cmake)
include(cmake/AddCommonLibraryDirectory.cmake)
enable_gtest()

# Include sub-projects.
add_subdirectory ("${CMAKE_CURRENT_LIST_DIR}/libraries")
add_subdirectory ("${CMAKE_CURRENT_LIST_DIR}/applications")

# add_subdirectory ("${CMAKE_CURRENT_LIST_DIR}/tests")
