#ifndef INTERFACE_LIB_MOCK_HPP
#define INTERFACE_LIB_MOCK_HPP

#include "InterfaceLib.hpp"
#include <gmock/gmock.h>

class InterfaceLibMock : public InterfaceLib {
public:
    MOCK_METHOD(void, doSomething, (), (override));
};

#endif
