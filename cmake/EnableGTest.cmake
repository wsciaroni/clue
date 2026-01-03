
# Use FetchContent to pull in GTest
# Call this ONCE from within the ROOT CMakeLists.txt of your project
macro(enable_gtest)

    # This creates the `BUILD_TESTING` option which defaults to ON
    # This runs `enable_testing()`
    include(CTest)

    if(BUILD_TESTING)
        include(FetchContent)
        FetchContent_Declare(
            googletest
            GIT_REPOSITORY https://github.com/google/googletest.git
            GIT_TAG v1.13.0
        )
        # For Windows: Prevent overriding the parent project's compiler/linker settings
        if(MSVC)
            set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
        endif(MSVC)

        # Check to see if googletest has already been populated so we only populate it once
        FetchContent_GetProperties(googletest)
        if(NOT googletest_POPULATED)

            # Populate the FetchContent
            FetchContent_MakeAvailable(googletest)

            # For Windows: Organize GoogleTest in the project explorer
            if(MSVC)
                set_target_properties(gtest PROPERTIES FOLDER "external/Google")
                set_target_properties(gmock PROPERTIES FOLDER "external/Google")
                set_target_properties(gtest_main PROPERTIES FOLDER "external/Google")
                set_target_properties(gmock_main PROPERTIES FOLDER "external/Google")
            endif(MSVC)
        endif()
    endif(BUILD_TESTING)
endmacro(enable_gtest)
