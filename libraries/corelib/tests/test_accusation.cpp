#include <gtest/gtest.h>
#include "GameEngine.h"

using namespace clue;

// Helper functions (duplicated from test_game_engine.cpp for now, or move to common)
inline Card create_suspect_acc(Suspect s) {
    Card c;
    c.set_type(CardType::CARD_TYPE_SUSPECT);
    c.set_suspect(s);
    return c;
}

inline Card create_weapon_acc(Weapon w) {
    Card c;
    c.set_type(CardType::CARD_TYPE_WEAPON);
    c.set_weapon(w);
    return c;
}

inline Card create_room_acc(Room r) {
    Card c;
    c.set_type(CardType::CARD_TYPE_ROOM);
    c.set_room(r);
    return c;
}

class AccusationTest : public ::testing::Test {
protected:
    GameEngine engine;
    InitGameRequest init_req;

    void SetUp() override {
        init_req.set_num_players(3);
        init_req.add_player_names("Me");
        init_req.add_player_names("Player1");
        init_req.add_player_names("Player2");
        // No initial hand for simplicity in these tests
        engine.initialize_game(init_req);
    }

    // Helper to get status
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
};

TEST_F(AccusationTest, CorrectAccusation) {
    Card s = create_suspect_acc(SUSPECT_COL_MUSTARD);
    Card w = create_weapon_acc(WEAPON_KNIFE);
    Card r = create_room_acc(ROOM_HALL);

    TurnData t;
    t.set_is_accusation(true);
    t.set_was_correct(true);
    *t.mutable_suspect() = s;
    *t.mutable_weapon() = w;
    *t.mutable_room() = r;

    engine.record_turn(t);
    GameStateResponse state = engine.get_game_state_response();

    // Check Probabilities: Mustard, Knife, Hall should be 1.0
    // Others should be 0.0
    for(const auto& prob : state.solution_probabilities()) {
        if (prob.card().type() == CardType::CARD_TYPE_SUSPECT) {
            if (prob.card().suspect() == SUSPECT_COL_MUSTARD) {
                EXPECT_FLOAT_EQ(prob.probability(), 1.0f);
            } else {
                EXPECT_FLOAT_EQ(prob.probability(), 0.0f);
                EXPECT_TRUE(prob.is_eliminated());
            }
        }
    }
}

TEST_F(AccusationTest, IncorrectAccusation) {
    Card s = create_suspect_acc(SUSPECT_COL_MUSTARD);
    Card w = create_weapon_acc(WEAPON_KNIFE);
    Card r = create_room_acc(ROOM_HALL);

    // 1. Incorrect Accusation (Mustard, Knife, Hall)
    TurnData t;
    t.set_is_accusation(true);
    t.set_was_correct(false);
    *t.mutable_suspect() = s;
    *t.mutable_weapon() = w;
    *t.mutable_room() = r;

    engine.record_turn(t);

    // 2. Establish Mustard is in Case File
    // P0 suggests Mustard, ..., ... and NO ONE answers.
    // P0 (Me) doesn't have it (empty hand). P1, P2 pass.
    // So Case File has Mustard.
    TurnData t2;
    t2.set_suggester_player_index(0);
    t2.set_responder_player_index(-1); // Everyone passed
    *t2.mutable_suspect() = s; // Mustard
    *t2.mutable_weapon() = create_weapon_acc(WEAPON_REVOLVER); // Filler
    *t2.mutable_room() = create_room_acc(ROOM_LOUNGE);     // Filler
    engine.record_turn(t2);

    // 3. Establish Knife is in Case File
    TurnData t3;
    t3.set_suggester_player_index(0);
    t3.set_responder_player_index(-1);
    *t3.mutable_suspect() = create_suspect_acc(SUSPECT_MR_GREEN); // Filler
    *t3.mutable_weapon() = w; // Knife
    *t3.mutable_room() = create_room_acc(ROOM_LOUNGE); // Filler
    engine.record_turn(t3);

    // Now Case File has {Mustard, Knife, ?}.
    // But we had an INCORRECT accusation of {Mustard, Knife, Hall}.
    // This implies Case File CANNOT be Hall.

    GameStateResponse state = engine.get_game_state_response();

    // Verify Mustard and Knife are 1.0
    // Verify Hall is 0.0
    bool hall_eliminated = false;
    bool mustard_confirmed = false;

    for(const auto& prob : state.solution_probabilities()) {
        if (prob.card().type() == CardType::CARD_TYPE_SUSPECT && prob.card().suspect() == SUSPECT_COL_MUSTARD) {
             EXPECT_FLOAT_EQ(prob.probability(), 1.0f);
             mustard_confirmed = true;
        }
        if (prob.card().type() == CardType::CARD_TYPE_ROOM && prob.card().room() == ROOM_HALL) {
            EXPECT_FLOAT_EQ(prob.probability(), 0.0f);
            EXPECT_TRUE(prob.is_eliminated());
            hall_eliminated = true;
        }
    }
    EXPECT_TRUE(mustard_confirmed);
    EXPECT_TRUE(hall_eliminated);
}
