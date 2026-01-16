#include <gtest/gtest.h>
#include "GameEngine.h"

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
        engine.initialize_game(init_req);
    }
};

TEST_F(GameEngineRecommendationTest, GetNextMoves_NoRoom) {
    // Should return 9 recommendations (one for each room)
    auto recs = engine.get_next_moves(std::nullopt);
    EXPECT_EQ(recs.size(), 9);

    // Verify they are recommendations
    for(const auto& r : recs) {
        EXPECT_EQ(r.suspect().type(), CardType::CARD_TYPE_SUSPECT);
        EXPECT_EQ(r.weapon().type(), CardType::CARD_TYPE_WEAPON);
        EXPECT_EQ(r.room().type(), CardType::CARD_TYPE_ROOM);
    }
}

TEST_F(GameEngineRecommendationTest, GetNextMoves_WithRoom) {
    // Should return 1 recommendation for the specific room
    auto recs = engine.get_next_moves(Room::ROOM_BALLROOM);
    EXPECT_EQ(recs.size(), 1);

    EXPECT_EQ(recs[0].room().room(), Room::ROOM_BALLROOM);
}

TEST_F(GameEngineRecommendationTest, GetAccusationRecommendation) {
    auto rec = engine.get_accusation_recommendation();
    EXPECT_EQ(rec.suspect().type(), CardType::CARD_TYPE_SUSPECT);
    EXPECT_EQ(rec.weapon().type(), CardType::CARD_TYPE_WEAPON);
    EXPECT_EQ(rec.room().type(), CardType::CARD_TYPE_ROOM);
    // Dummy value check
    EXPECT_FLOAT_EQ(rec.benefit(), 1.0f);
}
