#ifndef CLUE_GAME_ENGINE_H
#define CLUE_GAME_ENGINE_H

#include <vector>
#include <map>
#include <set>
#include <string>
#include <optional>
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
};

// Represents a disjunctive constraint (e.g., "Player B has Card1 OR Card2 OR Card3")
struct Constraint {
    int player_index;
    std::set<CardId> possible_cards; // The constraint is satisfied if the player has ONE of these
};

class GameEngine {
public:
    GameEngine();

    // Initialize the game with the number of players and the cards in "our" hand
    // num_players includes "us". Players are indexed 0 to num_players-1.
    // We are assumed to be Player 0.
    // The "Case File" (Envelope) is a special entity (tracked internally).
    void initialize(int num_players, const std::vector<Card>& my_hand,
                   int num_suspects = 6, int num_weapons = 6, int num_rooms = 9);

    // Record a turn where a suggestion was made
    // suggester_idx: Index of player making suggestion
    // suspect, weapon, room: The suggested cards
    // responder_idx: Index of player who responded (or -1 if nobody responded/all passed)
    // response_card: If we are the suggester, the card shown. If we are the responder, the card we showed.
    //                If we are an observer, this might be empty/unknown.
    // card_shown_to_me: True if the card was shown specifically to "me" (Player 0) or by "me".
    void process_suggestion(int suggester_idx,
                          const Card& suspect,
                          const Card& weapon,
                          const Card& room,
                          int responder_idx,
                          std::optional<Card> response_card = std::nullopt);

    // Run the solver to deduce new information
    void reconcile();

    // Query state
    CardState get_card_state(int player_idx, const CardId& card) const;
    CardState get_case_file_state(const CardId& card) const;

private:
    int m_num_players;

    // Grid: [PlayerIndex][CardId] -> State
    // We use a map for CardId to state for flexibility, or we could flatten it.
    std::map<int, std::map<CardId, CardState>> m_player_states;

    // Case File state
    std::map<CardId, CardState> m_case_file_state;

    // Constraints list
    std::vector<Constraint> m_constraints;

    // Helper to get all card IDs
    std::vector<CardId> m_all_cards;

    void register_card_types(int num_suspects, int num_weapons, int num_rooms);

    // Helper to mark a card as KNOWN_TRUE for a player
    // This also implies KNOWN_FALSE for everyone else (including Case File)
    void mark_card_true(int player_idx, const CardId& card);

    // Helper to mark a card as KNOWN_FALSE for a player
    void mark_card_false(int player_idx, const CardId& card);

    // Helper to check if a constraint is resolved
    bool resolve_constraint(const Constraint& c);

    // Solver steps
    bool solve_elimination(); // If a player has a card, others don't
    bool solve_case_file(); // If all players don't have it, Case File does (if type count permits)
    bool solve_constraints(); // Resolve pending constraints
};

} // namespace clue

#endif // CLUE_GAME_ENGINE_H
