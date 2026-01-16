#include <gtest/gtest.h>
#include "GameEngine.h"
#include <cmath>

using namespace clue;

class GameEngineRecommendationTest : public ::testing::Test {
protected:
    GameEngine engine;
    InitGameRequest init_req;

    void SetUp() override {
        init_req.set_num_players(3);
        init_req.add_player_names("Me");
        init_req.add_player_names("Player1");
        init_req.add_player_names("Player2");
        // Give me some cards so I'm not totally ignorant
        // Suspect 1, Weapon 1, Room 1 are mine.
        // This implies Case File is NOT S1, W1, R1.
        auto* c1 = init_req.add_my_hand();
        c1->set_type(CardType::CARD_TYPE_SUSPECT); c1->set_suspect(Suspect::SUSPECT_COL_MUSTARD); // ID 1

        auto* c2 = init_req.add_my_hand();
        c2->set_type(CardType::CARD_TYPE_WEAPON); c2->set_weapon(Weapon::WEAPON_KNIFE); // ID 1

        auto* c3 = init_req.add_my_hand();
        c3->set_type(CardType::CARD_TYPE_ROOM); c3->set_room(Room::ROOM_HALL); // ID 1

        // Card counts: 6 each? (18 + 3 = 21). 3 players -> 18 cards distributed. 3 in Case File.
        // 21 total. 3 in CF. 18 distributed.
        // P0 (Me): 3 cards (defined above).
        // Remaining 15 cards between P1 and P2?
        // Let's say P1 has 7, P2 has 8.
        init_req.add_player_card_counts(3);
        init_req.add_player_card_counts(7);
        init_req.add_player_card_counts(8);

        engine.initialize_game(init_req);
    }
};

TEST_F(GameEngineRecommendationTest, GetNextMoves_NoRoom) {
    // Should return 9 recommendations (one for each room)
    auto recs = engine.get_next_moves(std::nullopt);
    EXPECT_EQ(recs.size(), 9);

    // Verify they are recommendations
    bool has_benefit = false;
    for(const auto& r : recs) {
        EXPECT_EQ(r.suspect().type(), CardType::CARD_TYPE_SUSPECT);
        EXPECT_EQ(r.weapon().type(), CardType::CARD_TYPE_WEAPON);
        EXPECT_EQ(r.room().type(), CardType::CARD_TYPE_ROOM);
        if (std::abs(r.benefit()) > 0.0001f) has_benefit = true;
    }
    // With entropy based solver, benefit should be non-zero (positive or negative depending on cost vs entropy reduction)
    // Initially entropy reduction is positive. Cost is 0. So benefit > 0.
    EXPECT_TRUE(has_benefit);
}

TEST_F(GameEngineRecommendationTest, GetNextMoves_WithRoom) {
    // Should return 1 recommendation for the specific room
    auto recs = engine.get_next_moves(Room::ROOM_BALLROOM);
    EXPECT_EQ(recs.size(), 1);

    EXPECT_EQ(recs[0].room().room(), Room::ROOM_BALLROOM);
}

TEST_F(GameEngineRecommendationTest, GetAccusationRecommendation_Initial) {
    // Initially, we shouldn't be confident enough.
    auto rec = engine.get_accusation_recommendation();
    // Should be empty/default (CardType 0) or benefit 0
    if (rec.suspect().type() != CardType::CARD_TYPE_UNKNOWN) {
        EXPECT_LT(rec.benefit(), 0.95f);
    } else {
        // Correct, no recommendation
        EXPECT_EQ(rec.suspect().type(), CardType::CARD_TYPE_UNKNOWN);
    }
}
