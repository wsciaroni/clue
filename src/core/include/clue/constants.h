#pragma once

#include <string>
#include "SmartEnum.h"

#include <memory>

namespace Clue
{

const u_int8_t NUMBER_OF_SUSPECTS = 6;
const u_int8_t NUMBER_OF_WEAPONS = 6;
const u_int8_t NUMBER_OF_ROOMS = 9;
const u_int8_t NUMBER_OF_CARDS = NUMBER_OF_SUSPECTS + NUMBER_OF_WEAPONS + NUMBER_OF_ROOMS;
const u_int8_t NUMBER_OF_CARDS_IN_PLAYERS_HAND = 3;

const uint8_t NUMBER_OF_PLAYERS = 3;

BEGIN_SMART_ENUM(Card)
    ENUM_MEMBER(NONE)
    ENUM_MEMBER(MISS_SCARLET)
    ENUM_MEMBER(COLONEL_MUSTARD)
    ENUM_MEMBER(MRS_WHITE)
    ENUM_MEMBER(MR_GREEN)
    ENUM_MEMBER(MRS_PEACOCK)
    ENUM_MEMBER(PROFESSOR_PLUM)
    ENUM_MEMBER(CANDLESTICK)
    ENUM_MEMBER(DAGGER)
    ENUM_MEMBER(LEAD_PIPE)
    ENUM_MEMBER(REVOLVER)
    ENUM_MEMBER(ROPE)
    ENUM_MEMBER(WRENCH)
    ENUM_MEMBER(KITCHEN)
    ENUM_MEMBER(BALLROOM)
    ENUM_MEMBER(CONSERVATORY)
    ENUM_MEMBER(BILLIARD_ROOM)
    ENUM_MEMBER(LIBRARY)
    ENUM_MEMBER(STUDY)
    ENUM_MEMBER(HALL)
    ENUM_MEMBER(LOUNGE)
    ENUM_MEMBER(DINING_ROO)
END_SMART_ENUM(Card)

BEGIN_SMART_ENUM(Suspect)
    ENUM_MEMBER(NONE)
    ENUM_MEMBER(MISS_SCARLET)
    ENUM_MEMBER(COLONEL_MUSTARD)
    ENUM_MEMBER(MRS_WHITE)
    ENUM_MEMBER(MR_GREEN)
    ENUM_MEMBER(MRS_PEACOCK)
    ENUM_MEMBER(PROFESSOR_PLU)
END_SMART_ENUM(Suspect)

BEGIN_SMART_ENUM(Weapon)
    ENUM_MEMBER(NONE)
    ENUM_MEMBER(CANDLESTICK)
    ENUM_MEMBER(DAGGER)
    ENUM_MEMBER(LEAD_PIPE)
    ENUM_MEMBER(REVOLVER)
    ENUM_MEMBER(ROPE)
    ENUM_MEMBER(WRENCH)
END_SMART_ENUM(Weapon)

BEGIN_SMART_ENUM(Room)
    ENUM_MEMBER(NONE)
    ENUM_MEMBER(KITCHEN)
    ENUM_MEMBER(BALLROOM)
    ENUM_MEMBER(CONSERVATORY)
    ENUM_MEMBER(BILLIARD_ROOM)
    ENUM_MEMBER(LIBRARY)
    ENUM_MEMBER(STUDY)
    ENUM_MEMBER(HALL)
    ENUM_MEMBER(LOUNGE)
    ENUM_MEMBER(DINING_ROO)
END_SMART_ENUM(Room)

template<class T>
Card toCard(T suspect) {
    for (Card i = Card::FIRST; i < Card::LAST; ++i)
    {
        if (i.ToString() == suspect.ToString())
        {
            return i;
        }
    }
    return Card::INVALID;
}

template<class T>
Suspect fromCard (Card card) {
    for (T i = T::FIRST; i < T::LAST; ++i)
    {
        if (i.ToString() == card.ToString())
        {
            return i;
        }
    }
    return T::INVALID;
}

} // namespace Clue
