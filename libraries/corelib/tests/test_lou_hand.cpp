#include <gtest/gtest.h>
#include "GameEngine.h"
#include "clue.pb.h"
#include <iostream>

using namespace clue;

// Helper functions (copied/adapted from test_game_engine.cpp)
inline Card create_suspect(Suspect s) {
    Card c;
    c.set_type(CardType::CARD_TYPE_SUSPECT);
    c.set_suspect(s);
    return c;
}

inline Card create_weapon(Weapon w) {
    Card c;
    c.set_type(CardType::CARD_TYPE_WEAPON);
    c.set_weapon(w);
    return c;
}

inline Card create_room(Room r) {
    Card c;
    c.set_type(CardType::CARD_TYPE_ROOM);
    c.set_room(r);
    return c;
}

class LouHandTest : public ::testing::Test {
protected:
    GameEngine engine;
    InitGameRequest init_req;

    void SetUp() override {
        // Four players
        init_req.set_num_players(4);
        init_req.add_player_names("Abby"); // Me (Index 0)
        init_req.add_player_names("Lou");  // Index 1
        init_req.add_player_names("Kim");  // Index 2
        init_req.add_player_names("Will"); // Index 3

        // Card Counts
        // Abby (Me): 4
        // Lou: 4
        // Kim: 5
        // Will: 5
        init_req.add_player_card_counts(4);
        init_req.add_player_card_counts(4);
        init_req.add_player_card_counts(5);
        init_req.add_player_card_counts(5);

        // Abby's Hand (4 cards)
        // 1. Mustard (Suspect 1)
        // 2. Knife (Weapon 1)
        // 3. Hall (Room 1)
        // 4. Lounge (Room 2)
        *init_req.add_my_hand() = create_suspect(SUSPECT_COL_MUSTARD);
        *init_req.add_my_hand() = create_weapon(WEAPON_KNIFE);
        *init_req.add_my_hand() = create_room(ROOM_HALL);
        *init_req.add_my_hand() = create_room(ROOM_LOUNGE);

        engine.initialize_game(init_req);
    }

    // Helper to get status for a specific player and card
    CellState::Status get_status(const GameStateResponse& resp, int player_idx, CardType type, int id) {
        for(const auto& row : resp.rows()) {
            bool match = false;
            if(row.card().type() == type) {
                if(type == CardType::CARD_TYPE_SUSPECT && row.card().suspect() == (Suspect)id) match = true;
                if(type == CardType::CARD_TYPE_WEAPON && row.card().weapon() == (Weapon)id) match = true;
                if(type == CardType::CARD_TYPE_ROOM && row.card().room() == (Room)id) match = true;
            }
            if(match) {
                if(player_idx < row.player_states_size()) {
                    return row.player_states(player_idx).status();
                }
            }
        }
        return CellState::UNKNOWN;
    }

    // Helper to verify Lou's status for a card
    void VerifyLouStatus(const GameStateResponse& state, CardType type, int id, CellState::Status expected_status) {
        EXPECT_EQ(get_status(state, 1, type, id), expected_status)
            << "Mismatch for Player Lou (Index 1), Card Type " << type << ", ID " << id;
    }
};

TEST_F(LouHandTest, VerifyLouHandFilled) {
    // Turn 1: Abby suggests (Plum, Candlestick, Dining Room), Lou shows Plum.
    TurnData t1;
    t1.set_suggester_player_index(0); // Abby
    *t1.mutable_suspect() = create_suspect(SUSPECT_PROF_PLUM);
    *t1.mutable_weapon() = create_weapon(WEAPON_CANDLESTICK);
    *t1.mutable_room() = create_room(ROOM_DINING_ROOM);
    t1.set_responder_player_index(1); // Lou
    *t1.mutable_card_shown() = create_suspect(SUSPECT_PROF_PLUM); // Shows Plum
    engine.record_turn(t1);

    // Turn 2: Abby suggests (Green, Revolver, Kitchen), Lou shows Green.
    TurnData t2;
    t2.set_suggester_player_index(0);
    *t2.mutable_suspect() = create_suspect(SUSPECT_MR_GREEN);
    *t2.mutable_weapon() = create_weapon(WEAPON_REVOLVER);
    *t2.mutable_room() = create_room(ROOM_KITCHEN);
    t2.set_responder_player_index(1); // Lou
    *t2.mutable_card_shown() = create_suspect(SUSPECT_MR_GREEN); // Shows Green
    engine.record_turn(t2);

    // Turn 3: Abby suggests (Peacock, Rope, Ballroom), Lou shows Peacock.
    TurnData t3;
    t3.set_suggester_player_index(0);
    *t3.mutable_suspect() = create_suspect(SUSPECT_MRS_PEACOCK);
    *t3.mutable_weapon() = create_weapon(WEAPON_ROPE);
    *t3.mutable_room() = create_room(ROOM_BALLROOM);
    t3.set_responder_player_index(1); // Lou
    *t3.mutable_card_shown() = create_suspect(SUSPECT_MRS_PEACOCK); // Shows Peacock
    engine.record_turn(t3);

    // Turn 4: Abby suggests (Scarlet, Pipe, Conservatory), Lou shows Scarlet.
    TurnData t4;
    t4.set_suggester_player_index(0);
    *t4.mutable_suspect() = create_suspect(SUSPECT_MISS_SCARLET);
    *t4.mutable_weapon() = create_weapon(WEAPON_LEAD_PIPE);
    *t4.mutable_room() = create_room(ROOM_CONSERVATORY);
    t4.set_responder_player_index(1); // Lou
    *t4.mutable_card_shown() = create_suspect(SUSPECT_MISS_SCARLET); // Shows Scarlet
    engine.record_turn(t4);

    // Get final state
    GameStateResponse state = engine.get_game_state_response();

    // Verify Lou HAS the 4 cards shown
    VerifyLouStatus(state, CardType::CARD_TYPE_SUSPECT, SUSPECT_PROF_PLUM, CellState::HAS);
    VerifyLouStatus(state, CardType::CARD_TYPE_SUSPECT, SUSPECT_MR_GREEN, CellState::HAS);
    VerifyLouStatus(state, CardType::CARD_TYPE_SUSPECT, SUSPECT_MRS_PEACOCK, CellState::HAS);
    VerifyLouStatus(state, CardType::CARD_TYPE_SUSPECT, SUSPECT_MISS_SCARLET, CellState::HAS);

    // Verify Lou DOES_NOT_HAVE other cards
    // 1. Cards in Abby's hand (Mustard, Knife, Hall, Lounge) - Lou shouldn't have them
    VerifyLouStatus(state, CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD, CellState::DOES_NOT_HAVE);
    VerifyLouStatus(state, CardType::CARD_TYPE_WEAPON, WEAPON_KNIFE, CellState::DOES_NOT_HAVE);
    VerifyLouStatus(state, CardType::CARD_TYPE_ROOM, ROOM_HALL, CellState::DOES_NOT_HAVE);
    VerifyLouStatus(state, CardType::CARD_TYPE_ROOM, ROOM_LOUNGE, CellState::DOES_NOT_HAVE);

    // 2. Cards not shown by Lou (and not in Abby's hand)
    // Example: Mrs. White (Suspect 6)
    VerifyLouStatus(state, CardType::CARD_TYPE_SUSPECT, SUSPECT_MRS_WHITE, CellState::DOES_NOT_HAVE);

    // Example: Wrench (Weapon 6)
    VerifyLouStatus(state, CardType::CARD_TYPE_WEAPON, WEAPON_WRENCH, CellState::DOES_NOT_HAVE);

    // Example: Library (Room 8)
    VerifyLouStatus(state, CardType::CARD_TYPE_ROOM, ROOM_LIBRARY, CellState::DOES_NOT_HAVE);

    // Generally iterate over all cards to be thorough
    // Suspects 1-6
    for(int i=1; i<=6; ++i) {
        if(i == SUSPECT_PROF_PLUM || i == SUSPECT_MR_GREEN || i == SUSPECT_MRS_PEACOCK || i == SUSPECT_MISS_SCARLET) {
             VerifyLouStatus(state, CardType::CARD_TYPE_SUSPECT, i, CellState::HAS);
        } else {
             VerifyLouStatus(state, CardType::CARD_TYPE_SUSPECT, i, CellState::DOES_NOT_HAVE);
        }
    }

    // Weapons 1-6
    // Lou didn't show any weapons, so all should be DOES_NOT_HAVE
    for(int i=1; i<=6; ++i) {
         VerifyLouStatus(state, CardType::CARD_TYPE_WEAPON, i, CellState::DOES_NOT_HAVE);
    }

    // Rooms 1-9
    // Lou didn't show any rooms, so all should be DOES_NOT_HAVE
    for(int i=1; i<=9; ++i) {
         VerifyLouStatus(state, CardType::CARD_TYPE_ROOM, i, CellState::DOES_NOT_HAVE);
    }
}
