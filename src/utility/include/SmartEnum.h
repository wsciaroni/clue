/*
 * Copyright (c) Istvan Pasztor
 * This source has been published on www.codeproject.com under the CPOL license.
 */
#ifndef __SMART_ENUM_H__
#define __SMART_ENUM_H__
#pragma once

#include <cstring>
#include <cassert>

namespace SmartEnum
{
	struct Dummy {};
	template <typename T=Dummy>
	struct CompileError
	{
		typedef typename T::__YOU_DEFINED_MORE_THAN_THE_ALLOWD_NUMBER_OF_ENUM_MEMBERS__ TErr;
	};

	struct True { char a[1]; };
	struct False { char a[2]; };

	template<int N>
	struct Int
	{
		enum { Value = N };
	};

	template <bool COND, typename A, typename B>
	struct Select;
	template <typename A, typename B>
	struct Select<true, A, B> { typedef A Type; };
	template <typename A, typename B>
	struct Select<false, A, B> { typedef B Type; };

	typedef char value_type;
}


#define __NEXT_ENUM_VALUE(value_holder) \
	typedef \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<0>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<1>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<2>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<3>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<4>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<5>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<6>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<7>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<8>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<9>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<10>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<11>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<12>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<13>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<14>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<15>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<16>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<17>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<18>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<19>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<20>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<21>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<22>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<23>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<24>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<25>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<26>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<27>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<28>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<29>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<30>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<31>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::Select< sizeof(__ENUM_VAL_METHOD__((EnumClass*)0, (SmartEnum::Int<32>*)0)) == sizeof(SmartEnum::True), \
	SmartEnum::CompileError<>, \
	SmartEnum::Int<32> >::Type, \
	SmartEnum::Int<31> >::Type, \
	SmartEnum::Int<30> >::Type, \
	SmartEnum::Int<29> >::Type, \
	SmartEnum::Int<28> >::Type, \
	SmartEnum::Int<27> >::Type, \
	SmartEnum::Int<26> >::Type, \
	SmartEnum::Int<25> >::Type, \
	SmartEnum::Int<24> >::Type, \
	SmartEnum::Int<23> >::Type, \
	SmartEnum::Int<22> >::Type, \
	SmartEnum::Int<21> >::Type, \
	SmartEnum::Int<20> >::Type, \
	SmartEnum::Int<19> >::Type, \
	SmartEnum::Int<18> >::Type, \
	SmartEnum::Int<17> >::Type, \
	SmartEnum::Int<16> >::Type, \
	SmartEnum::Int<15> >::Type, \
	SmartEnum::Int<14> >::Type, \
	SmartEnum::Int<13> >::Type, \
	SmartEnum::Int<12> >::Type, \
	SmartEnum::Int<11> >::Type, \
	SmartEnum::Int<10> >::Type, \
	SmartEnum::Int<9> >::Type, \
	SmartEnum::Int<8> >::Type, \
	SmartEnum::Int<7> >::Type, \
	SmartEnum::Int<6> >::Type, \
	SmartEnum::Int<5> >::Type, \
	SmartEnum::Int<4> >::Type, \
	SmartEnum::Int<3> >::Type, \
	SmartEnum::Int<2> >::Type, \
	SmartEnum::Int<1> >::Type, \
	SmartEnum::Int<0> >::Type value_holder;

#define __NEXT_ENUM_VALUE_STEP(value_holder) \
	__NEXT_ENUM_VALUE(value_holder) \
	friend SmartEnum::True __ENUM_VAL_METHOD__(EnumClass*, value_holder*);

#define __ENUM_MEMBER_METHODS(member_name, primitive_enum, value_holder) \
	public: \
		EnumClass(primitive_enum val) { SetVal(val); } \
		EnumClass& operator=(primitive_enum val) { SetVal(val); return *this; } \
		__ENUM_MEMBER_OPERATORS(primitive_enum)

#define __ENUM_MEMBER_OPERATORS(primitive_enum) \
		friend bool operator==(const EnumClass& e, primitive_enum m) { return e.value == (SmartEnum::value_type)m; } \
		friend bool operator==(primitive_enum m, const EnumClass& e) { return e.value == (SmartEnum::value_type)m; } \
		friend bool operator!=(const EnumClass& e, primitive_enum m) { return e.value != (SmartEnum::value_type)m; } \
		friend bool operator!=(primitive_enum m, const EnumClass& e) { return e.value != (SmartEnum::value_type)m; } \
		friend bool operator>(const EnumClass& e, primitive_enum m) { return e.value > (SmartEnum::value_type)m; } \
		friend bool operator>(primitive_enum m, const EnumClass& e) { return e.value > (SmartEnum::value_type)m; } \
		friend bool operator>=(const EnumClass& e, primitive_enum m) { return e.value >= (SmartEnum::value_type)m; } \
		friend bool operator>=(primitive_enum m, const EnumClass& e) { return e.value >= (SmartEnum::value_type)m; } \
		friend bool operator<(const EnumClass& e, primitive_enum m) { return e.value < (SmartEnum::value_type)m; } \
		friend bool operator<(primitive_enum m, const EnumClass& e) { return e.value < (SmartEnum::value_type)m; } \
		friend bool operator<=(const EnumClass& e, primitive_enum m) { return e.value <= (SmartEnum::value_type)m; } \
		friend bool operator<=(primitive_enum m, const EnumClass& e) { return e.value <= (SmartEnum::value_type)m; }


#define BEGIN_SMART_ENUM(enum_name) \
	struct __##enum_name##__ \
	{ \
		class EnumClass \
		{ \
			friend SmartEnum::False __ENUM_VAL_METHOD__(EnumClass*, ...); \
		public: \
			EnumClass() { SetVal(LAST); } \
			operator SmartEnum::value_type() const { return value; } \
 \
			__NEXT_ENUM_VALUE(__VALUE_HOLDER_FIRST) \
			enum __EMember_FIRST { FIRST = __VALUE_HOLDER_FIRST::Value }; \
			__ENUM_MEMBER_METHODS(FIRST, __EMember_FIRST, __VALUE_HOLDER_FIRST)

#define ENUM_MEMBER(member_name) \
	private: \
		__NEXT_ENUM_VALUE_STEP(__VALUE_HOLDER_##member_name) \
	public: \
		enum __EMember_##member_name { member_name = __VALUE_HOLDER_##member_name::Value }; \
		__ENUM_MEMBER_METHODS(member_name, __EMember_##member_name, __VALUE_HOLDER_##member_name) \
	private: \
		static const char* ToString(__VALUE_HOLDER_##member_name*) { return #member_name; }

#ifdef _DEBUG
# define SMART_ENUM_DEBUG_SETVAL name = ToString();
# define SMART_ENUM_DEBUG_MEMBER const char* name;
#else
# define SMART_ENUM_DEBUG_SETVAL
# define SMART_ENUM_DEBUG_MEMBER
#endif

#define SMART_ENUM_ERROR_GUARD_CMP_OPERATOR(op) \
	template <typename T> friend bool operator op (const EnumClass& e, const T& t) { return e.value op t.__CAN_NOT_COMPARE_THIS_ENUM_TYPE_WITH_THIS_TYPE__; } \
	template <typename T> friend bool operator op (const T& t, const EnumClass& e) { return t.__CAN_NOT_COMPARE_THIS_ENUM_TYPE_WITH_THIS_TYPE__ op e.value; }

#define END_SMART_ENUM(enum_name) \
		public: \
			__NEXT_ENUM_VALUE(__VALUE_HOLDER_LAST) \
			enum __EMember_LAST { LAST = __VALUE_HOLDER_LAST::Value, COUNT = LAST, INVALID = LAST }; \
			__ENUM_MEMBER_METHODS(LAST, __EMember_LAST, __VALUE_HOLDER_LAST) \
 \
			static const SmartEnum::value_type FIRST_VAL = (SmartEnum::value_type)FIRST; \
			static const SmartEnum::value_type LAST_VAL = (SmartEnum::value_type)LAST; \
 \
		public: \
			static bool IsValid(const EnumClass& e) { return e.value>=FIRST_VAL && e.value<LAST_VAL; } \
			bool IsValid() const { return value>=FIRST_VAL && value<LAST_VAL; } \
			const char* ToString() const { return ToString(*this); } \
			static const char* ToString(const EnumClass& e) \
			{ \
				switch (e.value) \
				{ \
				case 0: return ToString((SmartEnum::Int<0>*)0); \
				case 1: return ToString((SmartEnum::Int<1>*)0); \
				case 2: return ToString((SmartEnum::Int<2>*)0); \
				case 3: return ToString((SmartEnum::Int<3>*)0); \
				case 4: return ToString((SmartEnum::Int<4>*)0); \
				case 5: return ToString((SmartEnum::Int<5>*)0); \
				case 6: return ToString((SmartEnum::Int<6>*)0); \
				case 7: return ToString((SmartEnum::Int<7>*)0); \
				case 8: return ToString((SmartEnum::Int<8>*)0); \
				case 9: return ToString((SmartEnum::Int<9>*)0); \
				case 10: return ToString((SmartEnum::Int<10>*)0); \
				case 11: return ToString((SmartEnum::Int<11>*)0); \
				case 12: return ToString((SmartEnum::Int<12>*)0); \
				case 13: return ToString((SmartEnum::Int<13>*)0); \
				case 14: return ToString((SmartEnum::Int<14>*)0); \
				case 15: return ToString((SmartEnum::Int<15>*)0); \
				case 16: return ToString((SmartEnum::Int<16>*)0); \
				case 17: return ToString((SmartEnum::Int<17>*)0); \
				case 18: return ToString((SmartEnum::Int<18>*)0); \
				case 19: return ToString((SmartEnum::Int<19>*)0); \
				case 20: return ToString((SmartEnum::Int<20>*)0); \
				case 21: return ToString((SmartEnum::Int<21>*)0); \
				case 22: return ToString((SmartEnum::Int<22>*)0); \
				case 23: return ToString((SmartEnum::Int<23>*)0); \
				case 24: return ToString((SmartEnum::Int<24>*)0); \
				case 25: return ToString((SmartEnum::Int<25>*)0); \
				case 26: return ToString((SmartEnum::Int<26>*)0); \
				case 27: return ToString((SmartEnum::Int<27>*)0); \
				case 28: return ToString((SmartEnum::Int<28>*)0); \
				case 29: return ToString((SmartEnum::Int<29>*)0); \
				case 30: return ToString((SmartEnum::Int<30>*)0); \
				case 31: return ToString((SmartEnum::Int<31>*)0); \
				default: return "INVALID"; \
				} \
			} \
 \
			static EnumClass FromString(const char* s) \
			{ \
				if (LAST_VAL == 0) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<0>*)0), s)) return EnumClass(0); \
				if (LAST_VAL == 1) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<1>*)0), s)) return EnumClass(1); \
				if (LAST_VAL == 2) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<2>*)0), s)) return EnumClass(2); \
				if (LAST_VAL == 3) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<3>*)0), s)) return EnumClass(3); \
				if (LAST_VAL == 4) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<4>*)0), s)) return EnumClass(4); \
				if (LAST_VAL == 5) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<5>*)0), s)) return EnumClass(5); \
				if (LAST_VAL == 6) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<6>*)0), s)) return EnumClass(6); \
				if (LAST_VAL == 7) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<7>*)0), s)) return EnumClass(7); \
				if (LAST_VAL == 8) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<8>*)0), s)) return EnumClass(8); \
				if (LAST_VAL == 9) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<9>*)0), s)) return EnumClass(9); \
				if (LAST_VAL == 10) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<10>*)0), s)) return EnumClass(10); \
				if (LAST_VAL == 11) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<11>*)0), s)) return EnumClass(11); \
				if (LAST_VAL == 12) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<12>*)0), s)) return EnumClass(12); \
				if (LAST_VAL == 13) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<13>*)0), s)) return EnumClass(13); \
				if (LAST_VAL == 14) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<14>*)0), s)) return EnumClass(14); \
				if (LAST_VAL == 15) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<15>*)0), s)) return EnumClass(15); \
				if (LAST_VAL == 16) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<16>*)0), s)) return EnumClass(16); \
				if (LAST_VAL == 17) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<17>*)0), s)) return EnumClass(17); \
				if (LAST_VAL == 18) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<18>*)0), s)) return EnumClass(18); \
				if (LAST_VAL == 19) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<19>*)0), s)) return EnumClass(19); \
				if (LAST_VAL == 20) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<20>*)0), s)) return EnumClass(20); \
				if (LAST_VAL == 21) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<21>*)0), s)) return EnumClass(21); \
				if (LAST_VAL == 22) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<22>*)0), s)) return EnumClass(22); \
				if (LAST_VAL == 23) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<23>*)0), s)) return EnumClass(23); \
				if (LAST_VAL == 24) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<24>*)0), s)) return EnumClass(24); \
				if (LAST_VAL == 25) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<25>*)0), s)) return EnumClass(25); \
				if (LAST_VAL == 26) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<26>*)0), s)) return EnumClass(26); \
				if (LAST_VAL == 27) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<27>*)0), s)) return EnumClass(27); \
				if (LAST_VAL == 28) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<28>*)0), s)) return EnumClass(28); \
				if (LAST_VAL == 29) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<29>*)0), s)) return EnumClass(29); \
				if (LAST_VAL == 30) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<30>*)0), s)) return EnumClass(30); \
				if (LAST_VAL == 31) return EnumClass(); \
				if (!strcmp(ToString((SmartEnum::Int<31>*)0), s)) return EnumClass(31); \
				return EnumClass(); \
			} \
 \
			friend bool operator==(const EnumClass& e1, const EnumClass& e2) { return e1.value == e2.value; } \
			friend bool operator!=(const EnumClass& e1, const EnumClass& e2) { return e1.value != e2.value; } \
			friend bool operator>(const EnumClass& e1, const EnumClass& e2) { return e1.value > e2.value; } \
			friend bool operator>=(const EnumClass& e1, const EnumClass& e2) { return e1.value >= e2.value; } \
			friend bool operator<(const EnumClass& e1, const EnumClass& e2) { return e1.value < e2.value; } \
			friend bool operator<=(const EnumClass& e1, const EnumClass& e2) { return e1.value <= e2.value; } \
			SMART_ENUM_ERROR_GUARD_CMP_OPERATOR( == ) \
			SMART_ENUM_ERROR_GUARD_CMP_OPERATOR( != ) \
			SMART_ENUM_ERROR_GUARD_CMP_OPERATOR( > ) \
			SMART_ENUM_ERROR_GUARD_CMP_OPERATOR( >= ) \
			SMART_ENUM_ERROR_GUARD_CMP_OPERATOR( < ) \
			SMART_ENUM_ERROR_GUARD_CMP_OPERATOR( <= ) \
			EnumClass& operator++() \
			{ \
				SetVal_NoRangeCheck(value+1); \
				return *this; \
			} \
			EnumClass operator++(int) \
			{ \
				EnumClass orig = *this; \
				SetVal_NoRangeCheck(value+1); \
				return orig; \
			} \
			EnumClass& operator--() \
			{ \
				SetVal_NoRangeCheck(value-1); \
				return *this; \
			} \
			EnumClass operator--(int) \
			{ \
				EnumClass orig = *this; \
				SetVal_NoRangeCheck(value-1); \
				return orig; \
			} \
 \
		private: \
			template <typename T> \
			static const char* ToString(T*) { return "INVALID"; } \
 \
			EnumClass(int i) { SetVal(i); } \
 \
			void SetVal(int i) \
			{ \
				assert(i>=FIRST_VAL && i<=LAST_VAL); \
				value = (SmartEnum::value_type)i; \
				SMART_ENUM_DEBUG_SETVAL \
			} \
			void SetVal_NoRangeCheck(int i) \
			{ \
				value = (SmartEnum::value_type)i; \
				SMART_ENUM_DEBUG_SETVAL \
			} \
 \
		private: \
			SmartEnum::value_type value; \
			SMART_ENUM_DEBUG_MEMBER \
		}; \
	}; \
	typedef __##enum_name##__::EnumClass enum_name;

#endif
