file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")
file(GLOB_RECURSE includes CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h")

add_library(CORElib STATIC ${sources} ${includes})

target_include_directories(CORElib PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(CORElib PUBLIC Qt${QT_VERSION_MAJOR}::Widgets)
target_link_libraries(CORElib PUBLIC UTILITYlib)
target_link_libraries(clue PUBLIC CORElib)

file(GLOB_RECURSE unittests CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/test/*.cpp")

add_executable(
  CORETest
  ${unittests}
)
target_link_libraries(
    CORETest
    PUBLIC
    CORElib
    GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(CORETest)