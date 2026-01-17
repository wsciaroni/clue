#ifndef CLUE_SOLVER_H
#define CLUE_SOLVER_H

#include <vector>
#include <bitset>
#include <cmath>
#include <map>
#include <optional>
#include "clue.pb.h"
#include "Types.h"

namespace clue {

// 21 Cards: 6 Suspects, 6 Weapons, 9 Rooms
constexpr int NUM_CARDS = 21;
using CardMask = std::bitset<NUM_CARDS>;

class ClueSolver {
public:
    ClueSolver();

    void initialize(int num_players, const std::vector<Card>& my_hand, const std::vector<int>& card_counts);
    void process_turn(const TurnData& turn, const std::vector<int>& card_counts);

    // Returns recommendations for a specific room or all rooms if nullopt
    std::vector<Recommendation> get_suggestions(std::optional<Room> target_room) const;

    // Returns an accusation if confidence is high enough
    std::optional<Recommendation> get_accusation_recommendation() const;

    // Mapping Helpers
    static int get_card_index(const Card& card);
    static int get_card_index(const CardId& card_id);
    static CardId get_card_from_index(int index);
    static Card from_card_id(const CardId& id);

    // Debug helper
    float get_probability(int card_index, int owner_index) const;

private:
    int m_num_players; // Players only (does not include Case File)
    std::vector<int> m_player_card_counts;

    // Probabilities[card_index][owner_index]
    // Owners: 0..N-1 (Players), N (Case File)
    std::vector<std::vector<float>> m_probabilities;

    // Weights
    float w_b = 1.0f;
    float w_d = 0.5f;

    // Distance Matrix (9x9)
    // Indexes 0..8 corresponding to Rooms 1..9
    static const int ROOM_DISTANCES[9][9];

    // Helpers
    void reset_probabilities();
    void enforce_constraints();
    void normalize_row(int card_index);
    float calculate_entropy_case_file() const;
    float calculate_entropy(const std::vector<float>& probs) const;

    // Updates
    void update_belief_pass(int player_index, int s_idx, int w_idx, int r_idx);
    void update_belief_show(int player_index, int s_idx, int w_idx, int r_idx, int shown_card_idx = -1);
};

} // namespace clue

#endif // CLUE_SOLVER_H
