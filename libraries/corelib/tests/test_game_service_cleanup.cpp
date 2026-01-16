#include <gtest/gtest.h>
#include "ClueGameServiceImpl.h"
#include <chrono>
#include <thread>
#include <string>

// Test fixture for GameService cleanup
class ClueGameServiceCleanupTest : public ::testing::Test {
protected:
    void SetUp() override {
    }

    void TearDown() override {
    }
};

TEST_F(ClueGameServiceCleanupTest, GameCleanupTest) {
    // 100ms timeout, check every 10ms
    ClueGameServiceImpl service(std::chrono::milliseconds(100), std::chrono::milliseconds(10));

    // Create a game
    clue::InitGameRequest init_req;
    init_req.set_num_players(3);
    init_req.add_player_names("P1");
    init_req.add_player_names("P2");
    init_req.add_player_names("P3");

    clue::InitGameResponse init_resp;
    service.InitGame(nullptr, &init_req, &init_resp);

    EXPECT_TRUE(init_resp.success());
    std::string game_id = init_resp.game_id();
    EXPECT_FALSE(game_id.empty());

    // Verify game exists
    clue::GameStateRequest state_req;
    state_req.set_game_id(game_id);
    clue::GameStateResponse state_resp;
    service.GetGameState(nullptr, &state_req, &state_resp);
    // If game exists, game_id in response should match
    EXPECT_EQ(state_resp.game_id(), game_id);

    // Wait for > 100ms
    std::this_thread::sleep_for(std::chrono::milliseconds(200));

    // Verify game is gone
    clue::GameStateResponse state_resp2;
    service.GetGameState(nullptr, &state_req, &state_resp2);
    // If game does not exist, response game_id is empty (based on implementation of GetGameState)
    EXPECT_EQ(state_resp2.game_id(), "");
}

TEST_F(ClueGameServiceCleanupTest, GameKeepAliveTest) {
    // 200ms timeout, check every 10ms
    ClueGameServiceImpl service(std::chrono::milliseconds(200), std::chrono::milliseconds(10));

    // Create a game
    clue::InitGameRequest init_req;
    init_req.set_num_players(3);
    init_req.add_player_names("P1");
    init_req.add_player_names("P2");
    init_req.add_player_names("P3");

    clue::InitGameResponse init_resp;
    service.InitGame(nullptr, &init_req, &init_resp);

    EXPECT_TRUE(init_resp.success());
    std::string game_id = init_resp.game_id();

    // Ping every 50ms for 300ms total (so it would timeout if not pinged)
    for (int i = 0; i < 6; ++i) {
        std::this_thread::sleep_for(std::chrono::milliseconds(50));
        clue::GameStateRequest state_req;
        state_req.set_game_id(game_id);
        clue::GameStateResponse state_resp;
        service.GetGameState(nullptr, &state_req, &state_resp);
        EXPECT_EQ(state_resp.game_id(), game_id) << "Game disappeared at iteration " << i;
    }

    // Now stop pinging and wait for timeout
    std::this_thread::sleep_for(std::chrono::milliseconds(250));

    clue::GameStateRequest state_req;
    state_req.set_game_id(game_id);
    clue::GameStateResponse state_resp;
    service.GetGameState(nullptr, &state_req, &state_resp);
    EXPECT_EQ(state_resp.game_id(), "") << "Game should have been removed";
}
