add_executable(clue_simulator
    main.cpp
)

target_link_libraries(clue_simulator PRIVATE
    coreLib
    clue_messages
)

target_include_directories(clue_simulator PRIVATE
    ${CMAKE_SOURCE_DIR}/libraries/corelib/include
    ${CMAKE_SOURCE_DIR}/libraries/messages
)
