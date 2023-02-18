#include "SmartEnum.h"

#include <gtest/gtest.h>

BEGIN_SMART_ENUM(MyEnum)
	ENUM_MEMBER(member0)
	ENUM_MEMBER(member1)
	ENUM_MEMBER(member2)
	ENUM_MEMBER(member3)
	ENUM_MEMBER(member4)
	ENUM_MEMBER(member5)
	ENUM_MEMBER(member6)
	ENUM_MEMBER(member7)
	ENUM_MEMBER(member8)
	ENUM_MEMBER(member9)
	ENUM_MEMBER(member10)
	ENUM_MEMBER(member11)
	ENUM_MEMBER(member12)
	ENUM_MEMBER(member13)
	ENUM_MEMBER(member14)
	ENUM_MEMBER(member15)
	ENUM_MEMBER(member16)
	ENUM_MEMBER(member17)
	ENUM_MEMBER(member18)
	ENUM_MEMBER(member19)
	ENUM_MEMBER(member20)
	ENUM_MEMBER(member21)
	ENUM_MEMBER(member22)
	ENUM_MEMBER(member23)
	ENUM_MEMBER(member24)
#ifdef __CAUSE_TOO_MANY_ENUM_MEMBERS_COMPILE_ERROR__
	ENUM_MEMBER(member25)
	ENUM_MEMBER(member26)
	ENUM_MEMBER(member27)
	ENUM_MEMBER(member28)
	ENUM_MEMBER(member29)
	ENUM_MEMBER(member30)
	ENUM_MEMBER(member31)
	ENUM_MEMBER(member32)
#endif
END_SMART_ENUM(MyEnum)

class CMyClass
{
public:
	// enum inside a namespace
	BEGIN_SMART_ENUM(MyEnum2)
		ENUM_MEMBER(member1)
		ENUM_MEMBER(member2)
	END_SMART_ENUM(MyEnum2)
};


TEST(SmartEnumTestSuite, Instantiate) {
    EXPECT_NO_THROW(CMyClass c);
}

TEST(SmartEnumTestSuite, Eq) {
	EXPECT_EQ(MyEnum::FIRST,0);
	EXPECT_EQ(MyEnum::LAST, 25);
}

TEST(SmartEnumTestSuite, Loop) {
	int num = 0;
	for (MyEnum i=MyEnum::FIRST; i<MyEnum::LAST; ++i, num++) {
		std::string expectedString = "member" + std::to_string(num);
		EXPECT_STREQ(i.ToString(), expectedString.c_str());
	}

	EXPECT_EQ(MyEnum::ToString(MyEnum::INVALID), "INVALID");
}

TEST(SmartEnumTestSuite, InClass) {
	printf("MyEnum2: FIRST=%d, LAST=%d\n", CMyClass::MyEnum2::FIRST, CMyClass::MyEnum2::LAST);
	printf("%d. MyEnum2::%s\n", (int)CMyClass::MyEnum2::INVALID, CMyClass::MyEnum2::ToString(CMyClass::MyEnum2::INVALID));
	for (CMyClass::MyEnum2 i=CMyClass::MyEnum2::LAST; i-- > CMyClass::MyEnum2::FIRST;)
		printf("%d. MyEnum2::%s\n", (int)i, i.ToString());

}
