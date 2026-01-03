
if(BUILD_TESTING)
    # Tests
    file(GLOB_RECURSE unittests "${CMAKE_CURRENT_LIST_DIR}/unittests/*.cxx")
    add_executable(
    testLib
    ${unittests}
    )
    target_link_libraries(
        testLib
        PUBLIC
        coreLib
        GTest::gtest_main
        GTest::gmock_main
    )

    include(GoogleTest)
    gtest_discover_tests(testLib)
endif(BUILD_TESTING)
