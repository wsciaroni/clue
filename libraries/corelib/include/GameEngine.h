#ifndef CLUE_GAME_ENGINE_H
#define CLUE_GAME_ENGINE_H

#include <vector>
#include <map>
#include <set>
#include <string>
#include <optional>
#include "clue.pb.h"
#include "ClueSolver.h"
#include "Types.h"

namespace clue {

class GameEngine {
public:
    GameEngine();

    // Initialize a new session
    // This sets the base state which is restored upon reset/replay.
    void initialize_game(const InitGameRequest& request);

    // Appends a new turn and updates state
    void record_turn(const TurnData& turn_data);

    // Modifies an existing turn and replays the game
    bool update_turn(const std::string& turn_id, const TurnData& new_data);

    // Removes a specific turn by ID and replays
    bool delete_turn(const std::string& turn_id);

    // Removes the last turn and replays
    bool undo_last_turn();

    // Returns the history
    std::vector<TurnEntry> get_history() const;

    // Returns the full game state suitable for the frontend
    GameStateResponse get_game_state_response() const;

    // Returns a list of suggested moves (suggestions)
    // If room is specified, returns suggestions only for that room.
    // Otherwise returns one suggestion per room.
    std::vector<Recommendation> get_next_moves(std::optional<Room> room) const;

    // Returns the best recommended accusation
    Recommendation get_accusation_recommendation() const;

private:
    // Game Configuration
    InitGameRequest m_init_request;
    bool m_initialized = false;
    std::vector<CardId> m_all_cards;

    // History (Event Sourcing)
    std::vector<TurnEntry> m_history;
    int m_next_turn_number = 1;

    // Current State (Calculated)
    // Grid: [PlayerIndex][CardId] -> State
    std::map<int, std::map<CardId, CardState>> m_player_states;
    // Case File state
    std::map<CardId, CardState> m_case_file_state;
    // Constraints list
    std::vector<Constraint> m_constraints;
    // Case File constraints (e.g. Accusation incorrect -> Case File does not have {S, W, R})
    // Each set represents a tuple of cards where AT LEAST ONE is NOT in the Case File.
    // Actually, "Incorrect Accusation" means (CaseFile != S OR CaseFile != W OR CaseFile != R).
    // Which is equivalent to: NOT (CaseFile == S AND CaseFile == W AND CaseFile == R).
    // Since Case File has exactly one of each type, this means at least one card in the accusation is NOT in the case file.
    std::vector<std::set<CardId>> m_case_file_constraints;

    // --- Core Logic Methods ---

    // Resets the state to the initial configuration (players, my hand)
    // Clears all deductions and constraints.
    void reset_state();

    // Replays all turns in history
    void replay_game();

    // Processes a single turn's logic (updates state/constraints)
    // This does NOT add to history, it just applies logic.
    void apply_turn_logic(const TurnData& data);

    void register_card_types();

    // Helper to mark a card as KNOWN_TRUE for a player
    // This also implies KNOWN_FALSE for everyone else (including Case File)
    void mark_card_true(int player_idx, const CardId& card);

    // Helper to mark a card as KNOWN_FALSE for a player
    void mark_card_false(int player_idx, const CardId& card);

    // Solver steps
    void reconcile();
    bool solve_elimination();
    bool solve_case_file();
    bool solve_constraints();

    // Helpers
    CardId to_card_id(const Card& c) const;
    Card from_card_id(const CardId& id) const;

    // Hand size tracking
    std::vector<int> m_player_card_counts;
    bool solve_hand_size();

    // Probabilistic Solver
    ClueSolver m_solver;
};

} // namespace clue

#endif // CLUE_GAME_ENGINE_H
