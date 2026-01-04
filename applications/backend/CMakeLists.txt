add_executable(clue_backend
    "${CMAKE_CURRENT_LIST_DIR}/main.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/ClueGameServiceImpl.cpp"
)

target_include_directories(clue_backend PRIVATE "${CMAKE_CURRENT_LIST_DIR}/include")

target_link_libraries(clue_backend PRIVATE coreLib clue_messages)

# Tests
if(BUILD_TESTING)
    # We don't need find_package(GTest) because we use FetchContent in root
    add_executable(backend_tests
        "${CMAKE_SOURCE_DIR}/libraries/corelib/tests/test_game_engine.cpp"
    )
    target_include_directories(backend_tests PRIVATE
        "${CMAKE_CURRENT_LIST_DIR}/include"
        "${CMAKE_SOURCE_DIR}/libraries/corelib/include"
    )
    target_link_libraries(backend_tests PRIVATE coreLib clue_messages gtest_main)

    add_test(NAME backend_tests COMMAND backend_tests)
endif()
