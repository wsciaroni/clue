#ifndef CORE_MOCK_HPP
#define CORE_MOCK_HPP

#include <gmock/gmock.h>

class CoreMock {
public:
    MOCK_METHOD(void, foo, ());
};

#endif
