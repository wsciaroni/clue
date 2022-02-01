cmake_minimum_required(VERSION 3.16.3)

project(clue_proj VERSION 0.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#find_package(Qt6 COMPONENTS Widgets REQUIRED)

add_executable(clue
    ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
)

# add_subdirectory(utility)