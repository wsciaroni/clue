#include <gtest/gtest.h>
#include "InterfaceLibMock.hpp"

TEST(InterfaceLibTest, CanInstantiateMock) {
    InterfaceLibMock mock;
    EXPECT_CALL(mock, doSomething()).Times(0);
}
