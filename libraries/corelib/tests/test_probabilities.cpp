#include <gtest/gtest.h>
#include "GameEngine.h"

using namespace clue;

class ProbabilityTest : public ::testing::Test {
protected:
    GameEngine engine;
    InitGameRequest init_req;

    void SetUp() override {
        init_req.set_num_players(3);
        init_req.add_player_names("Me");
        init_req.add_player_names("Player1");
        init_req.add_player_names("Player2");

        // P0 (Me) has Mustard and Knife
        Card c1; c1.set_type(CardType::CARD_TYPE_SUSPECT); c1.set_suspect(SUSPECT_COL_MUSTARD);
        Card c2; c2.set_type(CardType::CARD_TYPE_WEAPON); c2.set_weapon(WEAPON_KNIFE);
        *init_req.add_my_hand() = c1;
        *init_req.add_my_hand() = c2;

        engine.initialize_game(init_req);
    }
};

TEST_F(ProbabilityTest, InitialProbabilities) {
    GameStateResponse state = engine.get_game_state_response();

    // Suspects: 6 total.
    // Mustard is in my hand -> 0% to be solution.
    // Remaining 5 are unknown -> should be 1/5 = 0.20

    int mustard_found = 0;
    int green_found = 0;

    for(const auto& sp : state.solution_probabilities()) {
        if (sp.card().type() == CardType::CARD_TYPE_SUSPECT) {
            if (sp.card().suspect() == SUSPECT_COL_MUSTARD) {
                EXPECT_FLOAT_EQ(sp.probability(), 0.0f);
                mustard_found++;
            } else if (sp.card().suspect() == SUSPECT_MR_GREEN) {
                // Should be 0.2
                EXPECT_NEAR(sp.probability(), 0.2f, 0.001f);
                green_found++;
            }
        }
    }
    EXPECT_EQ(mustard_found, 1);
    EXPECT_EQ(green_found, 1);
}

TEST_F(ProbabilityTest, AfterElimination) {
    // Eliminate Miss Scarlet (Player 1 has it)
    TurnData t;
    t.set_suggester_player_index(0);
    Card s; s.set_type(CardType::CARD_TYPE_SUSPECT); s.set_suspect(SUSPECT_MISS_SCARLET);
    Card w; w.set_type(CardType::CARD_TYPE_WEAPON); w.set_weapon(WEAPON_ROPE);
    Card r; r.set_type(CardType::CARD_TYPE_ROOM); r.set_room(ROOM_HALL);

    *t.mutable_suspect() = s;
    *t.mutable_weapon() = w;
    *t.mutable_room() = r;
    t.set_responder_player_index(1);
    *t.mutable_card_shown() = s; // Show Scarlet

    engine.record_turn(t);

    GameStateResponse state = engine.get_game_state_response();

    // Suspects: 6 total.
    // Mustard (My hand) -> Eliminated.
    // Scarlet (Shown by P1) -> Eliminated.
    // Remaining 4 (Plum, Green, White, Peacock) -> 1/4 = 0.25

    for(const auto& sp : state.solution_probabilities()) {
        if (sp.card().type() == CardType::CARD_TYPE_SUSPECT) {
            if (sp.card().suspect() == SUSPECT_MISS_SCARLET) {
                EXPECT_FLOAT_EQ(sp.probability(), 0.0f);
            } else if (sp.card().suspect() == SUSPECT_MR_GREEN) {
                EXPECT_NEAR(sp.probability(), 0.25f, 0.001f);
            }
        }
    }
}
