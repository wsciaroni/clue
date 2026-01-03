#ifndef UTILITY_MOCK_HPP
#define UTILITY_MOCK_HPP

#include <gmock/gmock.h>

class UtilityMock {
public:
    MOCK_METHOD(void, bar, ());
};

#endif
