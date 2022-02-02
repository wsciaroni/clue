file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

add_library(CORElib STATIC ${sources})

target_include_directories(CORElib PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include")

target_link_libraries(clue PUBLIC CORElib)