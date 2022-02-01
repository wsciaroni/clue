file(GLOB_RECURSE lib_source CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

add_library(UIlib ${lib_source})
target_include_directories(UIlib PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(UIlib PUBLIC Qt::Widgets)
target_link_libraries(clue UIlib)