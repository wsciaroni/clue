#include "ClueSolver.h"
#include <iostream>
#include <algorithm>
#include <numeric>

namespace clue {

// Mapping:
// Suspects (1-6) -> 0-5
// Weapons (1-6) -> 6-11
// Rooms (1-9) -> 12-20

int ClueSolver::get_card_index(const CardId& card_id) {
    if (card_id.type == CardType::CARD_TYPE_SUSPECT) {
        return card_id.id - 1;
    } else if (card_id.type == CardType::CARD_TYPE_WEAPON) {
        return 6 + (card_id.id - 1);
    } else if (card_id.type == CardType::CARD_TYPE_ROOM) {
        return 12 + (card_id.id - 1);
    }
    return -1;
}

int ClueSolver::get_card_index(const Card& card) {
    CardId id;
    id.type = card.type();
    if (id.type == CardType::CARD_TYPE_SUSPECT) id.id = card.suspect();
    else if (id.type == CardType::CARD_TYPE_WEAPON) id.id = card.weapon();
    else if (id.type == CardType::CARD_TYPE_ROOM) id.id = card.room();
    return get_card_index(id);
}

CardId ClueSolver::get_card_from_index(int index) {
    CardId id;
    if (index < 6) {
        id.type = CardType::CARD_TYPE_SUSPECT;
        id.id = index + 1;
    } else if (index < 12) {
        id.type = CardType::CARD_TYPE_WEAPON;
        id.id = index - 6 + 1;
    } else {
        id.type = CardType::CARD_TYPE_ROOM;
        id.id = index - 12 + 1;
    }
    return id;
}

// Distance Matrix
// Approximate distances on standard board.
// H(1) L(2) D(3) K(4) B(5) C(6) Bi(7) Li(8) S(9)
// Grid layout approximation:
// S  H  L
// Li B  D
// C  Bi K
// 1: Hall (0,1)
// 2: Lounge (0,2)
// 3: Dining (1,2)
// 4: Kitchen (2,2)
// 5: Ballroom (2,1)
// 6: Conservatory (2,0)
// 7: Billiard (1,1) -> Wait, Billiard is usually middle-ish?
// Let's use a standard Manhattan distance approximation on a 3x3 grid for simplicity
// or hardcode connectivity.
// 3x3 Grid:
// [0,0] Study(9)    [0,1] Hall(1)      [0,2] Lounge(2)
// [1,0] Library(8)  [1,1] Billiard(7)  [1,2] Dining(3)
// [2,0] Conserv(6)  [2,1] Ballroom(5)  [2,2] Kitchen(4)
//
// Mapping to index (0..8 for Rooms 1..9):
// Room 1 (Hall) -> (0,1)
// Room 2 (Lounge) -> (0,2)
// Room 3 (Dining) -> (1,2)
// Room 4 (Kitchen) -> (2,2)
// Room 5 (Ballroom) -> (2,1)
// Room 6 (Conserv) -> (2,0)
// Room 7 (Billiard) -> (1,1)
// Room 8 (Library) -> (1,0)
// Room 9 (Study) -> (0,0)
//
// Manhattan Distance: |x1-x2| + |y1-y2|
// Secret passages: Study(9)<->Kitchen(4) (dist=1), Lounge(2)<->Conserv(6) (dist=1).

struct Point { int r, c; };
Point get_coord(int room_val) {
    switch(room_val) {
        case 1: return {0,1}; // Hall
        case 2: return {0,2}; // Lounge
        case 3: return {1,2}; // Dining
        case 4: return {2,2}; // Kitchen
        case 5: return {2,1}; // Ballroom
        case 6: return {2,0}; // Conserv
        case 7: return {1,1}; // Billiard
        case 8: return {1,0}; // Library
        case 9: return {0,0}; // Study
        default: return {0,0};
    }
}

int calc_dist(int r1, int r2) {
    if (r1 == r2) return 0;
    // Secret passages
    if ((r1==9 && r2==4) || (r1==4 && r2==9)) return 1;
    if ((r1==2 && r2==6) || (r1==6 && r2==2)) return 1;

    Point p1 = get_coord(r1);
    Point p2 = get_coord(r2);
    // Base Manhattan distance on 3x3 grid is a rough proxy for turns
    // Real board has corridors, but this preserves relative locality.
    // Scale factor: adjacent rooms are usually ~3-4 spaces.
    // But "Distance" in formula D(t_k) is likely "turns".
    // 1 die roll ~ 3.5 spaces. Adjacent rooms often reachable in 1 turn if roll high.
    // Let's just use Manhattan distance as "turns" approximation.
    return std::abs(p1.r - p2.r) + std::abs(p1.c - p2.c);
}

// Initializing the static matrix manually because C++ static array init can be messy in header
const int ClueSolver::ROOM_DISTANCES[9][9] = {
    // 1  2  3  4  5  6  7  8  9
    {0, 1, 2, 3, 2, 3, 1, 2, 1}, // 1 Hall
    {1, 0, 1, 2, 3, 1, 2, 3, 2}, // 2 Lounge (Has passage to 6, so dist 2->6 is 1)
    {2, 1, 0, 1, 2, 3, 1, 2, 3}, // 3 Dining
    {3, 2, 1, 0, 1, 2, 2, 3, 1}, // 4 Kitchen (Has passage to 9, so dist 4->9 is 1)
    {2, 3, 2, 1, 0, 1, 1, 2, 3}, // 5 Ballroom
    {3, 1, 3, 2, 1, 0, 1, 1, 2}, // 6 Conserv (Has passage to 2, so dist 6->2 is 1)
    {1, 2, 1, 2, 1, 1, 0, 1, 2}, // 7 Billiard
    {2, 3, 2, 3, 2, 1, 1, 0, 1}, // 8 Library
    {1, 2, 3, 1, 3, 2, 2, 1, 0}  // 9 Study (Has passage to 4, so dist 9->4 is 1)
};

ClueSolver::ClueSolver() : m_num_players(0) {}

void ClueSolver::initialize(int num_players, const std::vector<Card>& my_hand, const std::vector<int>& card_counts) {
    m_num_players = num_players;
    m_player_card_counts = card_counts;

    // Rows: 21 cards
    // Cols: num_players + 1 (last is Case File)
    int num_cols = m_num_players + 1;
    m_probabilities.assign(NUM_CARDS, std::vector<float>(num_cols, 0.0f));

    // Initial Probability Assignment
    // 1. My Hand (Player 0) is known.
    // 2. Others are distributed among remaining players and Case File.

    std::bitset<NUM_CARDS> my_cards;
    for (const auto& c : my_hand) {
        int idx = get_card_index(c);
        if (idx >= 0) {
            my_cards.set(idx);
            m_probabilities[idx][0] = 1.0f; // I have it
             // Others have 0, handled by initial 0.0 or normalize
        }
    }

    // Calculate remaining cards distribution
    // Total cards - My Hand
    // Each other card could be in Case File OR in any opponent's hand.
    // However, Case File has structure: 1 Suspect, 1 Weapon, 1 Room.

    // For each card type group (Suspects, Weapons, Rooms):
    // Count how many are in my hand.
    // The rest are potential Case File candidates.
    // P(Card in Case File) = 1 / (Total in Group - Known in Hand? No).
    // Actually, P(Card is Case File) = 1/6 (if none known).
    // If I have 2 suspects, then remaining 4 have P=1/4 of being Case File?
    // Yes.

    // Logic:
    // For a card C NOT in my hand:
    // P(C in Case File) = P(Type is Case File) / (Count of unknowns in Type)
    // P(C in Opponent X) = Remaining Prob / Sum of Opponent Card Counts?
    // This is getting complex. Let's start uniform for unknowns.

    // Standard approach:
    // Assign 1.0 to Knowns (My Hand).
    // For Unknowns:
    //   P(Case File) = 1 / (Total of Type - Count of Type in My Hand)
    //   Remaining Probability = 1.0 - P(Case File)
    //   Distribute Remaining equally among Opponents?
    //   Or proportional to their card counts.

    // Let's do Proportional allocation.

    int my_suspects = 0, my_weapons = 0, my_rooms = 0;
    for (int i=0; i<6; ++i) if (my_cards[i]) my_suspects++;
    for (int i=6; i<12; ++i) if (my_cards[i]) my_weapons++;
    for (int i=12; i<21; ++i) if (my_cards[i]) my_rooms++;

    for (int i = 0; i < NUM_CARDS; ++i) {
        if (my_cards[i]) {
            // Already set to 1.0 for Player 0, others 0.
            continue;
        }

        float p_case_file = 0.0f;
        if (i < 6) p_case_file = 1.0f / (6 - my_suspects);
        else if (i < 12) p_case_file = 1.0f / (6 - my_weapons);
        else p_case_file = 1.0f / (9 - my_rooms);

        m_probabilities[i][m_num_players] = p_case_file;

        // Remaining probability for opponents
        float p_remaining = 1.0f - p_case_file;

        // Distribute based on card counts?
        // Total opponent cards
        int total_opp_cards = 0;
        for (int p=1; p<m_num_players; ++p) total_opp_cards += m_player_card_counts[p];

        for (int p=1; p<m_num_players; ++p) {
            if (total_opp_cards > 0) {
                m_probabilities[i][p] = p_remaining * ((float)m_player_card_counts[p] / total_opp_cards);
            } else {
                m_probabilities[i][p] = p_remaining / (m_num_players - 1);
            }
        }
    }
}

void ClueSolver::normalize_row(int card_index) {
    float sum = 0.0f;
    for (float p : m_probabilities[card_index]) sum += p;
    if (sum > 0) {
        for (float& p : m_probabilities[card_index]) p /= sum;
    }
}

void ClueSolver::enforce_constraints() {
    // Categories: Suspects (0-5), Weapons (6-11), Rooms (12-20)
    std::vector<std::pair<int, int>> ranges = {{0, 6}, {6, 12}, {12, 21}};

    for (const auto& range : ranges) {
        int start = range.first;
        int end = range.second;
        int cf_index = m_num_players;

        // Check if any card in this category is KNOWN to be in Case File
        int known_cf_card = -1;
        for (int i = start; i < end; ++i) {
            if (m_probabilities[i][cf_index] >= 0.99f) {
                known_cf_card = i;
                break;
            }
        }

        if (known_cf_card != -1) {
            // If one card is in CF, all others in this category are NOT in CF.
            for (int i = start; i < end; ++i) {
                if (i != known_cf_card) {
                    // Set P(CF) = 0
                    m_probabilities[i][cf_index] = 0.0f;
                    // Renormalize to distribute remaining probability to players
                    normalize_row(i);
                }
            }
        }
    }
}

void ClueSolver::process_turn(const TurnData& turn, const std::vector<int>& card_counts) {
    // 1. Identification
    int suggester = turn.suggester_player_index();
    int s_idx = get_card_index(turn.suspect());
    int w_idx = get_card_index(turn.weapon());
    int r_idx = get_card_index(turn.room());

    if (s_idx < 0 || w_idx < 0 || r_idx < 0) return; // Invalid

    int responder = turn.responder_player_index();

    // 2. Update for Passers (Everyone between Suggester and Responder)
    int current = (suggester + 1) % m_num_players;
    int end = (responder == -1) ? suggester : responder;

    while (current != end) {
        update_belief_pass(current, s_idx, w_idx, r_idx);
        current = (current + 1) % m_num_players;
    }

    // 3. Update for Responder
    if (responder != -1) {
        int shown = -1;
        if (turn.has_card_shown()) {
            shown = get_card_index(turn.card_shown());
        }
        update_belief_show(responder, s_idx, w_idx, r_idx, shown);
    }

    // 4. If Accusation (and successful/failed), handle that too.
    // (Handled by GameEngine logic mostly, but we should update probs if we want accuracy)
    if (turn.is_accusation()) {
        if (turn.was_correct()) {
            // Case File IS {S, W, R}
            // Logic is absolute here.
            for (int c=0; c<NUM_CARDS; ++c) {
                 if (c == s_idx || c == w_idx || c == r_idx) {
                     // Set Case File prob to 1
                     for (int p=0; p<m_num_players; ++p) m_probabilities[c][p] = 0.0f;
                     m_probabilities[c][m_num_players] = 1.0f;
                 } else {
                     // If it's a Suspect but not S, Case File prob is 0.
                     // (Assuming only 1 suspect in CF)
                     bool is_suspect = (c < 6);
                     bool is_weapon = (c >= 6 && c < 12);
                     bool is_room = (c >= 12);

                     if ( (is_suspect && c!=s_idx) || (is_weapon && c!=w_idx) || (is_room && c!=r_idx) ) {
                         m_probabilities[c][m_num_players] = 0.0f;
                         normalize_row(c);
                     }
                 }
            }
        } else {
            // Case File is NOT {S, W, R} (i.e., at least one is wrong)
            // This is a constraint: NOT (CF_S && CF_W && CF_R)
            // Hard to model with marginals without joint state.
            // Ignored for marginal solver approximation for now.
        }
    }

    // Enforce mutual exclusivity constraints for Case File categories
    enforce_constraints();
}

void ClueSolver::update_belief_pass(int player_index, int s_idx, int w_idx, int r_idx) {
    // Player does not have S, W, or R.
    // Set P(S in Player) = 0, etc.
    m_probabilities[s_idx][player_index] = 0.0f;
    normalize_row(s_idx);

    m_probabilities[w_idx][player_index] = 0.0f;
    normalize_row(w_idx);

    m_probabilities[r_idx][player_index] = 0.0f;
    normalize_row(r_idx);
}

void ClueSolver::update_belief_show(int player_index, int s_idx, int w_idx, int r_idx, int shown_card_idx) {
    if (shown_card_idx != -1) {
        // We know exactly what was shown.
        m_probabilities[shown_card_idx][player_index] = 1.0f;
        // Logic: If P has it, no one else does.
        for (int p=0; p<=m_num_players; ++p) {
            if (p != player_index) m_probabilities[shown_card_idx][p] = 0.0f;
        }
    } else {
        // Player has at least one of S, W, R.
        // We boost the probability of them having S, W, R.
        // Simple Bayesian boost: P(Have | Show) propto P(Show | Have) * P(Have)
        // P(Show | Have S) = 1 (if they only have S). If they have S and W? Maybe 0.5.
        // Heuristic: Boost P(C in Player) for C in {S,W,R} by a factor.
        // Or simply: Do nothing? "Pass" gives more info than "Show" usually.
        // But "Show" confirms *someone* has it, meaning Case File probability decreases.

        // Let's implement a soft boost.
        // If Player *must* have one, then the probability they have none is 0.
        // But marginals don't capture "None".
        // However, we can decrease the Case File probability for these cards.
        // If P1 shows, then it's less likely S, W, R are in Case File.
        // But we don't know which one.

        // "Recursive Inference" implies using the likelihood.
        // Let's perform a small update:
        // P(P has S) increases. P(CF has S) decreases.
        // We can multiply P(P has S), P(P has W), P(P has R) by a factor > 1 (e.g. 1.5) and renormalize.
        float boost = 2.0f;
        m_probabilities[s_idx][player_index] *= boost;
        normalize_row(s_idx);

        m_probabilities[w_idx][player_index] *= boost;
        normalize_row(w_idx);

        m_probabilities[r_idx][player_index] *= boost;
        normalize_row(r_idx);
    }
}

float ClueSolver::calculate_entropy(const std::vector<float>& probs) const {
    float entropy = 0.0f;
    for (float p : probs) {
        if (p > 0.0001f) {
            entropy -= p * std::log2(p);
        }
    }
    return entropy;
}

float ClueSolver::calculate_entropy_case_file() const {
    // Entropy of Case File = Sum of Entropies of Suspect, Weapon, Room distributions (Independence assumption)
    // Actually, we want Entropy of the Case File *Candidates*.
    // H(CF) = H(S_cf) + H(W_cf) + H(R_cf).

    // Extract Case File Probabilities for Suspects
    std::vector<float> p_suspects;
    for(int i=0; i<6; ++i) p_suspects.push_back(m_probabilities[i][m_num_players]);

    std::vector<float> p_weapons;
    for(int i=6; i<12; ++i) p_weapons.push_back(m_probabilities[i][m_num_players]);

    std::vector<float> p_rooms;
    for(int i=12; i<21; ++i) p_rooms.push_back(m_probabilities[i][m_num_players]);

    // Normalize them (they should sum to 1 if we tracked correctly, but renormalization per row doesn't guarantee column sum logic for categories)
    // Actually, row normalization ensures Sum_owners P(Card in Owner) = 1.
    // It does NOT ensure Sum_cards_in_category P(Card in Case File) = 1.
    // We must re-normalize the column segments to treat them as a valid distribution for H calculation.

    auto normalize = [](std::vector<float>& v) {
        float sum = 0.0f;
        for(float f : v) sum += f;
        if (sum > 0) for(float& f : v) f /= sum;
    };

    normalize(p_suspects);
    normalize(p_weapons);
    normalize(p_rooms);

    return calculate_entropy(p_suspects) + calculate_entropy(p_weapons) + calculate_entropy(p_rooms);
}

std::vector<Recommendation> ClueSolver::get_suggestions(std::optional<Room> target_room) const {
    std::vector<Recommendation> recs;

    // If target_room is set, only evaluate that room.
    // If not, evaluate all 9 rooms.
    std::vector<int> rooms_to_eval;
    if (target_room.has_value()) {
        int r_idx = get_card_index({CardType::CARD_TYPE_ROOM, (int)target_room.value()});
        if (r_idx >= 12) rooms_to_eval.push_back(r_idx);
    } else {
        for (int i=12; i<21; ++i) rooms_to_eval.push_back(i);
    }

    float current_entropy = calculate_entropy_case_file();

    // Find best Suspect and Weapon to suggest (Heuristic: Highest Uncertainty/Entropy in Case File)
    // Actually, usually you want to suggest things that are likely in the Case File OR likely to be refuted by specific players.
    // High Entropy in Case File means we don't know. Suggesting it helps resolve it.
    // Let's pick top candidates based on P(Case File).

    // Sort Suspects by P(CF) desc
    std::vector<std::pair<float, int>> susp_probs;
    for(int i=0; i<6; ++i) susp_probs.push_back({m_probabilities[i][m_num_players], i});
    std::sort(susp_probs.rbegin(), susp_probs.rend());

    std::vector<std::pair<float, int>> weap_probs;
    for(int i=6; i<12; ++i) weap_probs.push_back({m_probabilities[i][m_num_players], i});
    std::sort(weap_probs.rbegin(), weap_probs.rend());

    // We only simulate the "Best" suggestion per room to save time?
    // Or iterate a few top combos.
    // Let's try the top 1 suspect and top 1 weapon for simplicity and performance.
    int best_s = susp_probs[0].second;
    int best_w = weap_probs[0].second;

    for (int r_idx : rooms_to_eval) {
        // Calculate Cost (Distance)
        // Assume start is unknown/irrelevant for now (Cost=0) or we could use average distance from center?
        // Prompt: "Distance (number of spaces/turns) to reach the target room".
        // Since we don't know current loc, let's assume distance = 0.
        float cost = 0.0f;

        // Calculate Benefit (EER)
        // Suggestion: S, W, R
        // Simulate Outcomes.
        // Simplified Simulation:
        // Outcome A: Someone Refutes (Entropy reduces).
        // Outcome B: Everyone Passes (Entropy reduces significantly - we found it).

        // Probability of Outcome A ~ Sum of P(Player has S/W/R)
        // Probability of Outcome B ~ P(S in CF) * P(W in CF) * P(R in CF)

        // To do this properly requires cloning the solver.
        // ClueSolver sim = *this;
        // ...
        // Since copying is cheap (21x5 matrix), we can do it.

        float expected_entropy = 0.0f;

        // Scenario 1: No one refutes (All Pass)
        // Prob = P(S in CF) * P(W in CF) * P(R in CF) (Approx)
        // Update: All players pass S, W, R.
        {
            ClueSolver sim = *this;
            for(int p=1; p<m_num_players; ++p) {
                sim.update_belief_pass(p, best_s, best_w, r_idx);
            }
            float h = sim.calculate_entropy_case_file();
            // Weight by probability of this outcome?
            // Calculating Prob of Outcome is hard.
            // Let's just average the entropy of outcomes?
            // "Benefit = Current - Sum(P(Outcome) * H_new)"
            // Assume 50/50 for Refute/Pass? No.
            // Let's approximate EER as: Entropy Reduction if Refuted vs Entropy Reduction if Passed.
            // Usually, Refutation is most likely.
            expected_entropy = h; // Placeholder if we assume pass.
        }

        // Scenario 2: Refutation
        // We don't know WHO refutes.
        // Average over next player refuting?
        {
            ClueSolver sim = *this;
            // Assume Player 1 (next) refutes
            // We don't know which card, but update_belief_show handles generic refutation.
            sim.update_belief_show(1, best_s, best_w, r_idx);
            float h_refute = sim.calculate_entropy_case_file();

            // Weighted average: 80% chance of refutation, 20% pass?
            // Depends on game stage.
            // Let's simplify: Benefit = Current - H_refute (Conservative estimate).
            expected_entropy = h_refute;
        }

        float eer = current_entropy - expected_entropy;

        Recommendation rec;
        *rec.mutable_suspect() = from_card_id(get_card_from_index(best_s));
        *rec.mutable_weapon() = from_card_id(get_card_from_index(best_w));
        *rec.mutable_room() = from_card_id(get_card_from_index(r_idx));

        float score = (w_b * eer) - (w_d * cost);
        rec.set_benefit(score);

        recs.push_back(rec);
    }

    // Sort by Benefit Descending
    std::sort(recs.begin(), recs.end(), [](const Recommendation& a, const Recommendation& b){
        return a.benefit() > b.benefit();
    });

    return recs;
}

std::optional<Recommendation> ClueSolver::get_accusation_recommendation() const {
    // Check if entropy is low enough or probability high enough
    // Thresholds: P > 0.95 or H < epsilon

    float p_threshold = 0.95f;

    // Find max P for each category
    float max_s = 0.0f; int s_idx = -1;
    for(int i=0; i<6; ++i) {
        if(m_probabilities[i][m_num_players] > max_s) { max_s = m_probabilities[i][m_num_players]; s_idx = i; }
    }

    float max_w = 0.0f; int w_idx = -1;
    for(int i=6; i<12; ++i) {
        if(m_probabilities[i][m_num_players] > max_w) { max_w = m_probabilities[i][m_num_players]; w_idx = i; }
    }

    float max_r = 0.0f; int r_idx = -1;
    for(int i=12; i<21; ++i) {
        if(m_probabilities[i][m_num_players] > max_r) { max_r = m_probabilities[i][m_num_players]; r_idx = i; }
    }

    // Combined confidence (assuming independence)
    // Or just require all 3 to be > 0.95 individually?
    // "if the highest probability candidate P(y_best) > 0.95"
    // y_best = (s, w, r). P(y) = P(s)*P(w)*P(r).
    float p_joint = max_s * max_w * max_r;

    if (p_joint > p_threshold) {
        Recommendation rec;
        *rec.mutable_suspect() = from_card_id(get_card_from_index(s_idx));
        *rec.mutable_weapon() = from_card_id(get_card_from_index(w_idx));
        *rec.mutable_room() = from_card_id(get_card_from_index(r_idx));
        rec.set_benefit(p_joint);
        return rec;
    }

    return std::nullopt;
}

float ClueSolver::get_probability(int card_index, int owner_index) const {
    if (card_index >= 0 && card_index < NUM_CARDS && owner_index < m_probabilities[card_index].size()) {
        return m_probabilities[card_index][owner_index];
    }
    return 0.0f;
}

Card ClueSolver::from_card_id(const CardId& id) {
    Card c;
    c.set_type(id.type);
    if (id.type == CardType::CARD_TYPE_SUSPECT) c.set_suspect((Suspect)id.id);
    else if (id.type == CardType::CARD_TYPE_WEAPON) c.set_weapon((Weapon)id.id);
    else if (id.type == CardType::CARD_TYPE_ROOM) c.set_room((Room)id.id);
    return c;
}

} // namespace clue
