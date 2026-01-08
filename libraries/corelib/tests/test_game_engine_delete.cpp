#include <gtest/gtest.h>
#include "GameEngine.h"

using namespace clue;

class GameEngineDeleteTest : public ::testing::Test {
protected:
    GameEngine engine;

    void SetUp() override {
        InitGameRequest request;
        request.set_num_players(3);
        request.add_player_names("P1");
        request.add_player_names("P2");
        request.add_player_names("P3");
        // No hand for simplicity
        engine.initialize_game(request);
    }
};

TEST_F(GameEngineDeleteTest, DeleteTurnSequentially) {
    TurnData t1;
    t1.set_suggester_player_index(0);
    t1.set_responder_player_index(-1); // Pass
    t1.mutable_suspect()->set_type(CardType::CARD_TYPE_SUSPECT); t1.mutable_suspect()->set_suspect(Suspect::SUSPECT_COL_MUSTARD);
    t1.mutable_weapon()->set_type(CardType::CARD_TYPE_WEAPON); t1.mutable_weapon()->set_weapon(Weapon::WEAPON_KNIFE);
    t1.mutable_room()->set_type(CardType::CARD_TYPE_ROOM); t1.mutable_room()->set_room(Room::ROOM_HALL);
    engine.record_turn(t1);

    TurnData t2;
    t2.set_suggester_player_index(1);
    t2.set_responder_player_index(-1);
    t2.mutable_suspect()->set_type(CardType::CARD_TYPE_SUSPECT); t2.mutable_suspect()->set_suspect(Suspect::SUSPECT_PROF_PLUM);
    t2.mutable_weapon()->set_type(CardType::CARD_TYPE_WEAPON); t2.mutable_weapon()->set_weapon(Weapon::WEAPON_ROPE);
    t2.mutable_room()->set_type(CardType::CARD_TYPE_ROOM); t2.mutable_room()->set_room(Room::ROOM_LOUNGE);
    engine.record_turn(t2);

    auto history = engine.get_history();
    ASSERT_EQ(history.size(), 2);
    std::string id1 = history[0].turn_id();
    std::string id2 = history[1].turn_id();

    // Delete first turn
    EXPECT_TRUE(engine.delete_turn(id1));

    history = engine.get_history();
    ASSERT_EQ(history.size(), 1);
    EXPECT_EQ(history[0].turn_id(), id2);
    // Verify turn number re-indexing
    EXPECT_EQ(history[0].turn_number(), 1);
}

TEST_F(GameEngineDeleteTest, DeleteNonExistentTurn) {
    EXPECT_FALSE(engine.delete_turn("invalid_id"));
}
