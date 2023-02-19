cmake_minimum_required(VERSION 3.16)

project(clue VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Have cmake create a compile database
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Allow the use of custom modules
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_LIST_DIR}/cmake/modules")
set(CPPCHECK_EXCLUDES "_deps;glog;test;\*_autogen;${CMAKE_CURRENT_LIST_DIR}/utility/external;${CMAKE_CURRENT_LIST_DIR}/clue_autogen;${CMAKE_CURRENT_LIST_DIR}/utility/UTILITYlib_autogen;${CMAKE_CURRENT_LIST_DIR}/core/CORElib_autogen;")
set(CPPCHECK_OTHER_ARGS "-Dlinux -DQ_MOC_OUTPUT_REVISION")
find_package(CppCheck)
if(CppCheck_FOUND)
    set(CMAKE_CXX_CPPCHECK ${CPPCHECK_BIN})
endif(CppCheck_FOUND)

include(FetchContent)
    FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.13.0
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()
include(CTest)

include(FetchContent)

set(WITH_GFLAGS OFF)
set(WITH_GTEST ON)
set(WITH_UNWIND ON) # May need to be off if you don't have libunwind or are on Windows
set(BUILD_TESTING OFF)

FetchContent_Declare(
    glog
    GIT_REPOSITORY https://github.com/google/glog.git
)
FetchContent_MakeAvailable(glog)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets LinguistTools REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets LinguistTools REQUIRED)

set(TS_FILES clue_en_US.ts)

set(PROJECT_SOURCES
        main.cpp
        mainwindow.cpp
        mainwindow.h
        mainwindow.ui
        configuregame.cpp
        configuregame.h
        configuregame.ui
        ${TS_FILES}
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(clue
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET clue APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
else()
    if(ANDROID)
        add_library(clue SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(clue
            ${PROJECT_SOURCES}
        )
    endif()

    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
endif()

target_link_libraries(clue PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)

set_target_properties(clue PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Add libraries
add_subdirectory(utility)
add_subdirectory(core)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(clue)
endif()
