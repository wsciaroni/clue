file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

add_library(UTILITYlib STATIC ${sources})

target_include_directories(UTILITYlib PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include")
# target_link_libraries(UTILITYlib PUBLIC Qt${QT_VERSION_MAJOR}::Widgets)
# target_link_libraries(clue PUBLIC UTILITYlib)