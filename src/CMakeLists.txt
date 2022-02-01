cmake_minimum_required(VERSION 3.16.3)

project(clue_proj VERSION 0.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#Qt applications typically make use of the Meta-Object Compiler (moc), Resource Compiler (rcc), and User Interface Compiler (uic) that come with Qt. Setting the CMAKE_AUTOMOC, CMAKE_AUTORCC, and CMAKE_AUTOUIC variables to ON will let CMake automatically set up rules so that the respective compilers are called transparently, when required.
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_FIND_DEBUG_MODE ON)
find_package(Qt6 6.2.3 EXACT REQUIRED COMPONENTS Widgets
    PATH_SUFFIXES
        6.2.3/gcc_64
)
set(CMAKE_FIND_DEBUG_MODE OFF)

add_executable(clue
    ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
)

add_subdirectory(ui)
