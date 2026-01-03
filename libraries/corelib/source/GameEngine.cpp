#include "GameEngine.h"
#include <algorithm>
#include <iostream>

namespace clue {

GameEngine::GameEngine() : m_num_players(0) {}

void GameEngine::initialize(int num_players, const std::vector<Card>& my_hand,
                           int num_suspects, int num_weapons, int num_rooms) {
    m_num_players = num_players;
    m_player_states.clear();
    m_case_file_state.clear();
    m_constraints.clear();
    m_all_cards.clear();

    register_card_types(num_suspects, num_weapons, num_rooms);

    // Initialize all states to UNKNOWN
    for (const auto& card : m_all_cards) {
        for (int i = 0; i < m_num_players; ++i) {
            m_player_states[i][card] = CardState::UNKNOWN;
        }
        m_case_file_state[card] = CardState::UNKNOWN;
    }

    // Process my hand (Player 0)
    std::set<CardId> my_hand_ids;
    for (const auto& card : my_hand) {
        CardId id;
        id.type = card.type();
        if (id.type == CardType::CARD_TYPE_SUSPECT) id.id = card.suspect();
        else if (id.type == CardType::CARD_TYPE_WEAPON) id.id = card.weapon();
        else if (id.type == CardType::CARD_TYPE_ROOM) id.id = card.room();

        mark_card_true(0, id);
        my_hand_ids.insert(id);
    }

    // Mark everything else as NOT in my hand
    for (const auto& card : m_all_cards) {
        if (my_hand_ids.find(card) == my_hand_ids.end()) {
            mark_card_false(0, card);
        }
    }
}

void GameEngine::register_card_types(int num_suspects, int num_weapons, int num_rooms) {
    for (int i = 1; i <= num_suspects; ++i) m_all_cards.push_back({CardType::CARD_TYPE_SUSPECT, i});
    for (int i = 1; i <= num_weapons; ++i) m_all_cards.push_back({CardType::CARD_TYPE_WEAPON, i});
    for (int i = 1; i <= num_rooms; ++i) m_all_cards.push_back({CardType::CARD_TYPE_ROOM, i});
}

CardState GameEngine::get_card_state(int player_idx, const CardId& card) const {
    auto p_it = m_player_states.find(player_idx);
    if (p_it != m_player_states.end()) {
        auto c_it = p_it->second.find(card);
        if (c_it != p_it->second.end()) return c_it->second;
    }
    return CardState::UNKNOWN;
}

CardState GameEngine::get_case_file_state(const CardId& card) const {
    auto it = m_case_file_state.find(card);
    if (it != m_case_file_state.end()) return it->second;
    return CardState::UNKNOWN;
}

void GameEngine::mark_card_true(int player_idx, const CardId& card) {
    if (m_player_states[player_idx][card] == CardState::KNOWN_TRUE) return; // Already known

    m_player_states[player_idx][card] = CardState::KNOWN_TRUE;

    // If this player has it, no one else does (including Case File)
    for (int i = 0; i < m_num_players; ++i) {
        if (i != player_idx) {
            mark_card_false(i, card);
        }
    }
    m_case_file_state[card] = CardState::KNOWN_FALSE;
}

void GameEngine::mark_card_false(int player_idx, const CardId& card) {
    m_player_states[player_idx][card] = CardState::KNOWN_FALSE;
}

void GameEngine::process_suggestion(int suggester_idx,
                                  const Card& suspect,
                                  const Card& weapon,
                                  const Card& room,
                                  int responder_idx,
                                  std::optional<Card> response_card) {

    CardId s_id = {CardType::CARD_TYPE_SUSPECT, (int)suspect.suspect()};
    CardId w_id = {CardType::CARD_TYPE_WEAPON, (int)weapon.weapon()};
    CardId r_id = {CardType::CARD_TYPE_ROOM, (int)room.room()};

    // Calculate pass logic: Everyone between suggester and responder (clockwise) passed.
    // If responder is -1, everyone passed.

    int current = (suggester_idx + 1) % m_num_players;
    int end = (responder_idx == -1) ? suggester_idx : responder_idx;

    // Loop handles wrapping. If responder is -1, loop until we hit suggester again.
    // Special case: if responder is -1, it means NO ONE had the cards.
    // So everyone except suggester gets marked false for these 3.
    // If responder is valid, loop stops AT responder (responder NOT included in pass loop).

    if (responder_idx == -1) {
         // Everyone passed!
         for (int i = 0; i < m_num_players; ++i) {
             if (i == suggester_idx) continue; // Suggester might have them (bluffing)
             mark_card_false(i, s_id);
             mark_card_false(i, w_id);
             mark_card_false(i, r_id);
         }
         // If everyone passed, the Case File MUST have them (unless suggester has them).
         // Actually, if everyone passed, and suggester checks his hand and sees he doesn't have them,
         // then they are in the envelope.
         // Logic for Case File: If P1, P2, P3... all don't have X, then CaseFile has X.
         // This is handled in reconcile().
         return;
    }

    // Mark passes
    while (current != responder_idx) {
        mark_card_false(current, s_id);
        mark_card_false(current, w_id);
        mark_card_false(current, r_id);
        current = (current + 1) % m_num_players;
    }

    // Handle Responder
    // If we know the card shown (because we are suggester, or we are responder, or it was just revealed)
    if (response_card.has_value()) {
        CardId c_id;
        c_id.type = response_card->type();
        if (c_id.type == CardType::CARD_TYPE_SUSPECT) c_id.id = response_card->suspect();
        else if (c_id.type == CardType::CARD_TYPE_WEAPON) c_id.id = response_card->weapon();
        else if (c_id.type == CardType::CARD_TYPE_ROOM) c_id.id = response_card->room();

        mark_card_true(responder_idx, c_id);
    } else {
        // We don't know which one, but we know responder has ONE of them.
        Constraint c;
        c.player_index = responder_idx;
        c.possible_cards.insert(s_id);
        c.possible_cards.insert(w_id);
        c.possible_cards.insert(r_id);
        m_constraints.push_back(c);
    }
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
    // Basic propagation is handled in mark_card_true/false, but we might check for:
    // "Player X has only 1 UNKNOWN card left, and needs 1 more card to fill hand size?"
    // (Hand size tracking isn't explicitly requested but is good advanced logic. skipping for now to keep simple).
    return false;
}

bool GameEngine::solve_case_file() {
    bool changed = false;
    for (const auto& card : m_all_cards) {
        // Check if Case File ALREADY knows
        if (m_case_file_state[card] != CardState::UNKNOWN) continue;

        // If all players are KNOWN_FALSE, Case File must be TRUE
        bool all_players_false = true;
        for (int i = 0; i < m_num_players; ++i) {
            if (m_player_states[i][card] != CardState::KNOWN_FALSE) {
                all_players_false = false;
                break;
            }
        }

        if (all_players_false) {
            m_case_file_state[card] = CardState::KNOWN_TRUE;
            // DANGER: If Case File has it, no one else does (already checked false).
            // Also, for that TYPE (e.g. Suspect), all other cards in Case File must be FALSE.
            // (There is only 1 suspect in the envelope).
            for (const auto& other_card : m_all_cards) {
                if (other_card.type == card.type && !(other_card == card)) {
                   if (m_case_file_state[other_card] != CardState::KNOWN_FALSE) {
                       m_case_file_state[other_card] = CardState::KNOWN_FALSE;
                       changed = true;
                   }
                }
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

        // Remove cards that are KNOWN_FALSE for this player
        auto cit = c.possible_cards.begin();
        while (cit != c.possible_cards.end()) {
            if (m_player_states[c.player_index][*cit] == CardState::KNOWN_FALSE) {
                cit = c.possible_cards.erase(cit);
                changed = true;
            } else if (m_player_states[c.player_index][*cit] == CardState::KNOWN_TRUE) {
                // The constraint is satisfied! Player HAS one of the cards.
                // We can remove the constraint.
                c.possible_cards.clear(); // Markers to remove
                break;
            } else {
                ++cit;
            }
        }

        if (c.possible_cards.empty()) {
             // Constraint satisfied or invalid (shouldn't happen if logic is sound)
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

} // namespace clue
