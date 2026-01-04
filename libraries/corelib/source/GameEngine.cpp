#include "GameEngine.h"
#include <algorithm>
#include <iostream>
#include <sstream>
#include <iomanip>
#include <random>

namespace clue {

// Helper to generate a simple ID
std::string generate_uuid() {
    static std::random_device rd;
    static std::mt19937 gen(rd());
    static std::uniform_int_distribution<> dis(0, 15);
    std::stringstream ss;
    for (int i = 0; i < 32; ++i) {
        int rc = dis(gen);
        ss << std::hex << rc;
    }
    return ss.str();
}

GameEngine::GameEngine() {}

void GameEngine::initialize_game(const InitGameRequest& request) {
    m_init_request = request;
    m_initialized = true;
    m_history.clear();
    m_next_turn_number = 1;

    register_card_types();
    reset_state();
}

void GameEngine::register_card_types() {
    m_all_cards.clear();
    // Assuming standard Clue counts for now, or could parameterize if needed.
    // Spec doesn't specify counts in InitGameRequest, so using defaults.
    // 6 Suspects, 6 Weapons, 9 Rooms.
    for (int i = 1; i <= 6; ++i) m_all_cards.push_back({CardType::CARD_TYPE_SUSPECT, i});
    for (int i = 1; i <= 6; ++i) m_all_cards.push_back({CardType::CARD_TYPE_WEAPON, i});
    for (int i = 1; i <= 9; ++i) m_all_cards.push_back({CardType::CARD_TYPE_ROOM, i});
}

void GameEngine::reset_state() {
    m_player_states.clear();
    m_case_file_state.clear();
    m_constraints.clear();

    int num_players = m_init_request.num_players();

    // Initialize all states to UNKNOWN
    for (const auto& card : m_all_cards) {
        for (int i = 0; i < num_players; ++i) {
            m_player_states[i][card] = CardState::UNKNOWN;
        }
        m_case_file_state[card] = CardState::UNKNOWN;
    }

    // Process my hand (Player 0 - assuming "us" is always index 0 or derived from names?
    // The spec says "User's hand = Known". We assume User is always a specific index.
    // Usually Player 0 is the user in this context, or we match names.
    // Let's assume user is index 0 for simplicity as per previous implementation logic.)

    // Actually, check InitGameRequest. It has "my_hand".
    // We'll assume "my_hand" belongs to the player at index 0 in "player_names" unless specified otherwise.
    // The previous code assumed "us" is Player 0.

    std::set<CardId> my_hand_ids;
    for (const auto& card : m_init_request.my_hand()) {
        CardId id = to_card_id(card);
        mark_card_true(0, id); // User is Player 0
        my_hand_ids.insert(id);
    }

    // Mark everything else as NOT in my hand (Player 0)
    for (const auto& card : m_all_cards) {
        if (my_hand_ids.find(card) == my_hand_ids.end()) {
            mark_card_false(0, card);
        }
    }
}

void GameEngine::record_turn(const TurnData& turn_data) {
    if (!m_initialized) return;

    TurnEntry entry;
    entry.set_turn_id(generate_uuid());
    entry.set_turn_number(m_next_turn_number++);
    *entry.mutable_data() = turn_data;

    m_history.push_back(entry);

    // Apply logic directly instead of full replay for efficiency on append
    apply_turn_logic(turn_data);
    reconcile();
}

bool GameEngine::update_turn(const std::string& turn_id, const TurnData& new_data) {
    auto it = std::find_if(m_history.begin(), m_history.end(),
        [&](const TurnEntry& entry) { return entry.turn_id() == turn_id; });

    if (it == m_history.end()) return false;

    *it->mutable_data() = new_data;

    replay_game();
    return true;
}

bool GameEngine::undo_last_turn() {
    if (m_history.empty()) return false;
    m_history.pop_back();
    m_next_turn_number--;
    replay_game();
    return true;
}

std::vector<TurnEntry> GameEngine::get_history() const {
    return m_history;
}

void GameEngine::replay_game() {
    reset_state();
    for (const auto& entry : m_history) {
        apply_turn_logic(entry.data());
        reconcile();
    }
}

void GameEngine::apply_turn_logic(const TurnData& data) {
    int num_players = m_init_request.num_players();
    int suggester_idx = data.suggester_player_index();
    int responder_idx = data.responder_player_index();

    CardId s_id = to_card_id(data.suspect());
    CardId w_id = to_card_id(data.weapon());
    CardId r_id = to_card_id(data.room());

    // Logic Rule 2: Players between A and B passed -> They DO NOT HAVE any of the 3 cards.
    int current = (suggester_idx + 1) % num_players;

    // If no one responded (-1), everyone else passed.
    // If someone responded, everyone between passed.

    // Stop condition for loop
    int stop_at = (responder_idx == -1) ? suggester_idx : responder_idx;

    if (responder_idx == -1) {
        // Everyone passed (except suggester who we don't know about via passing)
        // Loop wrapping around back to suggester
         int loop_curr = (suggester_idx + 1) % num_players;
         while (loop_curr != suggester_idx) {
             mark_card_false(loop_curr, s_id);
             mark_card_false(loop_curr, w_id);
             mark_card_false(loop_curr, r_id);
             loop_curr = (loop_curr + 1) % num_players;
         }
         // Suggestion was not refuted by anyone.
         // If suggester doesn't have them, they are in the envelope.
         // This is handled by reconcile/CaseFile logic implicitly if we know suggester hand.
    } else {
        // Passers
        while (current != responder_idx) {
            mark_card_false(current, s_id);
            mark_card_false(current, w_id);
            mark_card_false(current, r_id);
            current = (current + 1) % num_players;
        }

        // Logic Rule 2: Responder MUST have (Mustard OR Rope OR Hall)
        // If we know the card shown:
        if (data.has_card_shown()) {
            // Check if card_shown is actually set (proto3 optional or field presence)
            // The proto definition says 'optional Card card_shown = 6;'
            CardId c_id = to_card_id(data.card_shown());
            mark_card_true(responder_idx, c_id);
        } else {
            // We don't know which one, create constraint
            Constraint c;
            c.player_index = responder_idx;
            c.possible_cards.insert(s_id);
            c.possible_cards.insert(w_id);
            c.possible_cards.insert(r_id);
            m_constraints.push_back(c);
        }
    }

    // Note: Rule 2 says "Player A does NOT have Mustard... unless bluffing".
    // We usually don't assume Player A *doesn't* have them just because they suggested them.
    // Standard strategy often involves suggesting cards you have to confuse others.
    // So we do NOT mark suggester as NOT having them.
}

void GameEngine::reconcile() {
    bool changed = true;
    while (changed) {
        changed = false;
        changed |= solve_elimination();
        changed |= solve_case_file();
        changed |= solve_constraints();
    }
}

bool GameEngine::solve_elimination() {
    // Logic Rule 1 & 3 are handled here or in helpers.
    // Logic Rule 3: If constraint (A or B) and A is FALSE -> B must be TRUE.
    return false; // See solve_constraints
}

bool GameEngine::solve_case_file() {
    bool changed = false;
    for (const auto& card : m_all_cards) {
        if (m_case_file_state[card] != CardState::UNKNOWN) continue;

        bool all_players_false = true;
        for (int i = 0; i < m_init_request.num_players(); ++i) {
            if (m_player_states[i][card] != CardState::KNOWN_FALSE) {
                all_players_false = false;
                break;
            }
        }

        if (all_players_false) {
            m_case_file_state[card] = CardState::KNOWN_TRUE;
            // Case File has it, so it's the solution for that category.
            // All other cards of this type in Case File must be FALSE.
            for (const auto& other : m_all_cards) {
                if (other.type == card.type && other != card) {
                    if (m_case_file_state[other] != CardState::KNOWN_FALSE) {
                        m_case_file_state[other] = CardState::KNOWN_FALSE;
                        changed = true;
                    }
                }
            }
            changed = true;
        }
    }
    // Logic Rule: If all but one of a category are known to be elsewhere (KNOWN_FALSE in Case File),
    // then the last one must be in the Case File (KNOWN_TRUE).

    std::vector<CardType> categories = {CardType::CARD_TYPE_SUSPECT, CardType::CARD_TYPE_WEAPON, CardType::CARD_TYPE_ROOM};
    for (auto cat : categories) {
        int unknown_count = 0;
        CardId last_unknown;

        for (const auto& card : m_all_cards) {
            if (card.type != cat) continue;

            if (m_case_file_state[card] == CardState::UNKNOWN) {
                unknown_count++;
                last_unknown = card;
            } else if (m_case_file_state[card] == CardState::KNOWN_TRUE) {
                // Already solved for this category
                unknown_count = -1; // Flag as solved
                break;
            }
        }

        if (unknown_count == 1) {
            // Found it!
            m_case_file_state[last_unknown] = CardState::KNOWN_TRUE;

            // Mark as FALSE for all players
            for (int i = 0; i < m_init_request.num_players(); ++i) {
                mark_card_false(i, last_unknown);
            }
            changed = true;
        }
    }

    return changed;
}

bool GameEngine::solve_constraints() {
    bool changed = false;
    auto it = m_constraints.begin();
    while (it != m_constraints.end()) {
        Constraint& c = *it;

        // Logic Rule 3: Remove cards that are KNOWN_FALSE for this player
        auto cit = c.possible_cards.begin();
        while (cit != c.possible_cards.end()) {
            CardState s = m_player_states[c.player_index][*cit];
            if (s == CardState::KNOWN_FALSE) {
                cit = c.possible_cards.erase(cit);
                changed = true;
            } else if (s == CardState::KNOWN_TRUE) {
                // Constraint satisfied
                c.possible_cards.clear();
                break;
            } else {
                ++cit;
            }
        }

        if (c.possible_cards.empty()) {
             it = m_constraints.erase(it);
             continue;
        }

        if (c.possible_cards.size() == 1) {
            // Only one possibility left!
            CardId solved = *c.possible_cards.begin();
            mark_card_true(c.player_index, solved);
            changed = true;
            it = m_constraints.erase(it);
        } else {
            ++it;
        }
    }
    return changed;
}

void GameEngine::mark_card_true(int player_idx, const CardId& card) {
    if (m_player_states[player_idx][card] == CardState::KNOWN_TRUE) return;

    m_player_states[player_idx][card] = CardState::KNOWN_TRUE;

    // Logic Rule 1: If Player has it, others (and Case File) DO NOT.
    for (int i = 0; i < m_init_request.num_players(); ++i) {
        if (i != player_idx) {
            mark_card_false(i, card);
        }
    }
    m_case_file_state[card] = CardState::KNOWN_FALSE;
}

void GameEngine::mark_card_false(int player_idx, const CardId& card) {
    if (m_player_states[player_idx][card] == CardState::KNOWN_FALSE) return;
    m_player_states[player_idx][card] = CardState::KNOWN_FALSE;
    // Note: Marking false might trigger constraints in reconcile()
}

CardId GameEngine::to_card_id(const Card& c) const {
    CardId id;
    id.type = c.type();
    if (id.type == CardType::CARD_TYPE_SUSPECT) id.id = c.suspect();
    else if (id.type == CardType::CARD_TYPE_WEAPON) id.id = c.weapon();
    else if (id.type == CardType::CARD_TYPE_ROOM) id.id = c.room();
    return id;
}

Card GameEngine::from_card_id(const CardId& id) const {
    Card c;
    c.set_type(id.type);
    if (id.type == CardType::CARD_TYPE_SUSPECT) c.set_suspect((Suspect)id.id);
    else if (id.type == CardType::CARD_TYPE_WEAPON) c.set_weapon((Weapon)id.id);
    else if (id.type == CardType::CARD_TYPE_ROOM) c.set_room((Room)id.id);
    return c;
}

GameStateResponse GameEngine::get_game_state_response() const {
    GameStateResponse response;
    response.set_game_id("game_1"); // or managed elsewhere

    // Players
    for (int i = 0; i < m_init_request.num_players(); ++i) {
        PlayerInfo* p = response.add_players();
        p->set_index(i);
        if (i < m_init_request.player_names_size()) {
            p->set_name(m_init_request.player_names(i));
        } else {
            p->set_name("Player " + std::to_string(i));
        }
        // Card count not explicitly tracked yet but required by proto
        p->set_card_count(0);
    }

    // Rows
    for (const auto& card : m_all_cards) {
        GridRow* row = response.add_rows();
        *row->mutable_card() = from_card_id(card);

        for (int i = 0; i < m_init_request.num_players(); ++i) {
            CellState* cs = row->add_player_states();
            CardState internal_state = CardState::UNKNOWN;

            auto p_it = m_player_states.find(i);
            if (p_it != m_player_states.end()) {
                auto c_it = p_it->second.find(card);
                if (c_it != p_it->second.end()) internal_state = c_it->second;
            }

            if (internal_state == CardState::KNOWN_TRUE) cs->set_status(CellState::HAS);
            else if (internal_state == CardState::KNOWN_FALSE) cs->set_status(CellState::DOES_NOT_HAVE);
            else cs->set_status(CellState::UNKNOWN);
        }
    }

    // Solution Probabilities (from Case File state)
    for (const auto& card : m_all_cards) {
        SolutionProbability* sp = response.add_solution_probabilities();
        *sp->mutable_card() = from_card_id(card);
        CardState s = CardState::UNKNOWN;
        auto it = m_case_file_state.find(card);
        if (it != m_case_file_state.end()) s = it->second;

        if (s == CardState::KNOWN_FALSE) {
            sp->set_is_eliminated(true);
            sp->set_probability(0.0f);
        } else if (s == CardState::KNOWN_TRUE) {
            sp->set_is_eliminated(false);
            sp->set_probability(1.0f);
        } else {
            sp->set_is_eliminated(false);
            // Rough probability: 1 / (count of unknown cards of this type)
            // Ideally calculate this properly
            sp->set_probability(0.5f);
        }
    }

    return response;
}

} // namespace clue
