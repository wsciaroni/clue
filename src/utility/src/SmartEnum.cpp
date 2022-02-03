/*
 * Copyright (c) Istvan Pasztor
 * This source has been published on www.codeproject.com under the CPOL license.
 */
#include <cassert>
#include <cstdio>

#include "SmartEnum.h"

//#define __CAUSE_TOO_MANY_ENUM_MEMBERS_COMPILE_ERROR__

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


int main()
{
	printf("MyEnum: FIRST=%d, LAST=%d\n", MyEnum::FIRST, MyEnum::LAST);
	for (MyEnum i=MyEnum::FIRST; i<MyEnum::LAST; ++i)
		printf("%d. MyEnum::%s\n", (int)i, i.ToString());
	printf("%d. MyEnum::%s\n", (int)MyEnum::INVALID, MyEnum::ToString(MyEnum::INVALID));

	printf("MyEnum2: FIRST=%d, LAST=%d\n", CMyClass::MyEnum2::FIRST, CMyClass::MyEnum2::LAST);
	printf("%d. MyEnum2::%s\n", (int)CMyClass::MyEnum2::INVALID, CMyClass::MyEnum2::ToString(CMyClass::MyEnum2::INVALID));
	for (CMyClass::MyEnum2 i=CMyClass::MyEnum2::LAST; i-- > CMyClass::MyEnum2::FIRST;)
		printf("%d. MyEnum2::%s\n", (int)i, i.ToString());

	MyEnum e(MyEnum::member0);
	MyEnum f = e;
	CMyClass::MyEnum2 e2(CMyClass::MyEnum2::member1);
	
	// This would cause a compile error:
	//if (e2 == e)
	//{
	//	printf("************** EQUALS\n");
	//}
	
	f = MyEnum::member2;

	static const char STR[] = "member11";
	printf("FromString: %s=%d\n", STR, (int)MyEnum::FromString(STR));
	return 0;
}
