#pragma once

#include <string>

namespace Clue
{

enum class Card : __UINT8_TYPE__ {
    NONE = 0,

    MISS_SCARLET,
    COLONEL_MUSTARD,
    MRS_WHITE,
    MR_GREEN,
    MRS_PEACOCK,
    PROFESSOR_PLUM,

    CANDLESTICK,
    DAGGER,
    LEAD_PIPE,
    REVOLVER,
    ROPE,
    WRENCH,

    KITCHEN,
    BALLROOM,
    CONSERVATORY,
    BILLIARD_ROOM,
    LIBRARY,
    STUDY,
    HALL,
    LOUNGE,
    DINING_ROOM
};

enum class Suspect : __UINT8_TYPE__
{
    NONE = static_cast<__UINT8_TYPE__>(Card::NONE),
    MISS_SCARLET = static_cast<__UINT8_TYPE__>(Card::MISS_SCARLET),
    COLONEL_MUSTARD,
    MRS_WHITE,
    MR_GREEN,
    MRS_PEACOCK,
    PROFESSOR_PLUM
};

enum class Weapon : __UINT8_TYPE__
{
    NONE = static_cast<__UINT8_TYPE__>(Card::NONE),
    CANDLESTICK = static_cast<__UINT8_TYPE__>(Card::CANDLESTICK),
    DAGGER,
    LEAD_PIPE,
    REVOLVER,
    ROPE,
    WRENCH
};

enum class Room : __UINT8_TYPE__
{
    NONE = static_cast<__UINT8_TYPE__>(Card::NONE),
    KITCHEN = static_cast<__UINT8_TYPE__>(Card::KITCHEN),
    BALLROOM,
    CONSERVATORY,
    BILLIARD_ROOM,
    LIBRARY,
    STUDY,
    HALL,
    LOUNGE,
    DINING_ROOM
};

// Functions for printing out enums
static std::string toString(Card card) {
    switch (card)
    {
    case Card::MISS_SCARLET:
        return "MISS_SCARLET";
    case Card::COLONEL_MUSTARD:
        return "COLONEL_MUSTARD";
    case Card::MRS_WHITE:
        return "MRS_WHITE";
    case Card::MR_GREEN:
        return "MR_GREEN";
    case Card::MRS_PEACOCK:
        return "MRS_PEACOCK";
    case Card::PROFESSOR_PLUM:
        return "PROFESSOR_PLUM";
    
    case Card::CANDLESTICK:
        return "CANDLESTICK";
    case Card::DAGGER:
        return "DAGGER";
    case Card::LEAD_PIPE:
        return "LEAD_PIPE";
    case Card::REVOLVER:
        return "REVOLVER";
    case Card::ROPE:
        return "ROPE";
    case Card::WRENCH:
        return "WRENCH";

    case Card::KITCHEN:
        return "KITCHEN";
    case Card::BALLROOM:
        return "BALLROOM";
    case Card::CONSERVATORY:
        return "CONSERVATORY";
    case Card::BILLIARD_ROOM:
        return "BILLIARD_ROOM";
    case Card::LIBRARY:
        return "LIBRARY";
    case Card::STUDY:
        return "STUDY";
    case Card::HALL:
        return "HALL";
    case Card::LOUNGE:
        return "LOUNGE";
    case Card::DINING_ROOM:
        return "DINING_ROOM";
    case Card::NONE:
    default:
        return "NONE";
    }
}

static std::string toString(Suspect suspect) {
    switch (suspect)
    {
    case Suspect::MISS_SCARLET:
        return "MISS_SCARLET";
    case Suspect::COLONEL_MUSTARD:
        return "COLONEL_MUSTARD";
    case Suspect::MRS_WHITE:
        return "MRS_WHITE";
    case Suspect::MR_GREEN:
        return "MR_GREEN";
    case Suspect::MRS_PEACOCK:
        return "MRS_PEACOCK";
    case Suspect::PROFESSOR_PLUM:
        return "PROFESSOR_PLUM";
    case Suspect::NONE:
    default:
        return "NONE";
    }
}

static std::string toString(Weapon weapon) {
    switch (weapon)
    {
    case Weapon::CANDLESTICK:
        return "CANDLESTICK";
    case Weapon::DAGGER:
        return "DAGGER";
    case Weapon::LEAD_PIPE:
        return "LEAD_PIPE";
    case Weapon::REVOLVER:
        return "REVOLVER";
    case Weapon::ROPE:
        return "ROPE";
    case Weapon::WRENCH:
        return "WRENCH";
    case Weapon::NONE:
    default:
        return "NONE";
    }
}

static std::string toString(Room room) {
    switch (room) {
    case Room::KITCHEN:
        return "KITCHEN";
    case Room::BALLROOM:
        return "BALLROOM";
    case Room::CONSERVATORY:
        return "CONSERVATORY";
    case Room::BILLIARD_ROOM:
        return "BILLIARD_ROOM";
    case Room::LIBRARY:
        return "LIBRARY";
    case Room::STUDY:
        return "STUDY";
    case Room::HALL:
        return "HALL";
    case Room::LOUNGE:
        return "LOUNGE";
    case Room::DINING_ROOM:
        return "DINING_ROOM";
    case Room::NONE:
    default:
        return "NONE";
    }
}
} // namespace Clue
