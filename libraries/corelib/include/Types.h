#ifndef CLUE_TYPES_H
#define CLUE_TYPES_H

#include <set>
#include "clue.pb.h"

namespace clue {

enum class CardState {
    UNKNOWN,
    KNOWN_TRUE, // The player HAS this card
    KNOWN_FALSE // The player DOES NOT have this card
};

// Represents a unique identifier for a card
struct CardId {
    CardType type;
    int id; // Enum value of Suspect, Weapon, or Room

    bool operator<(const CardId& other) const {
        if (type != other.type) return type < other.type;
        return id < other.id;
    }
    bool operator==(const CardId& other) const {
        return type == other.type && id == other.id;
    }
    bool operator!=(const CardId& other) const {
        return !(*this == other);
    }
};

// Represents a disjunctive constraint (e.g., "Player B has Card1 OR Card2 OR Card3")
struct Constraint {
    int player_index;
    std::set<CardId> possible_cards; // The constraint is satisfied if the player has ONE of these
};

} // namespace clue

#endif // CLUE_TYPES_H
