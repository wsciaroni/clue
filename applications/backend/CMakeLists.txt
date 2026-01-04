add_executable(clue_backend "${CMAKE_CURRENT_LIST_DIR}/main.cpp")

target_link_libraries(clue_backend PRIVATE coreLib)
