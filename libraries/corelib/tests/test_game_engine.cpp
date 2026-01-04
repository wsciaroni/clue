#include <gtest/gtest.h>
#include "GameEngine.h"

using namespace clue;

// Helper to create cards
// Marked inline to avoid multiple definition errors
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

class GameEngineTest : public ::testing::Test {
protected:
    GameEngine engine;
    InitGameRequest init_req;

    void SetUp() override {
        init_req.set_num_players(3);
        init_req.add_player_names("Me");
        init_req.add_player_names("Player1");
        init_req.add_player_names("Player2");
        // P0 (Me) has Mustard and Knife
        Card c1 = create_suspect(SUSPECT_COL_MUSTARD);
        Card c2 = create_weapon(WEAPON_KNIFE);
        *init_req.add_my_hand() = c1;
        *init_req.add_my_hand() = c2;

        engine.initialize_game(init_req);
    }

    // Helper to get state from response
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

TEST_F(GameEngineTest, Initialization) {
    GameStateResponse state = engine.get_game_state_response();

    // Check my hand (Player 0)
    // Mustard -> HAS
    EXPECT_EQ(get_status(state, 0, CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD), CellState::HAS);
    // Knife -> HAS
    EXPECT_EQ(get_status(state, 0, CardType::CARD_TYPE_WEAPON, WEAPON_KNIFE), CellState::HAS);

    // Check others don't have it
    EXPECT_EQ(get_status(state, 1, CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD), CellState::DOES_NOT_HAVE);

    // Check unknown card (Plum)
    EXPECT_EQ(get_status(state, 0, CardType::CARD_TYPE_SUSPECT, SUSPECT_PROF_PLUM), CellState::DOES_NOT_HAVE); // I don't have it
    EXPECT_EQ(get_status(state, 1, CardType::CARD_TYPE_SUSPECT, SUSPECT_PROF_PLUM), CellState::UNKNOWN);
}

TEST_F(GameEngineTest, SimplePassLogic) {
    Card s = create_suspect(SUSPECT_MISS_SCARLET);
    Card w = create_weapon(WEAPON_ROPE);
    Card r = create_room(ROOM_HALL);

    // P0 Suggests, P1 Passes, P2 Responds
    TurnData t;
    t.set_suggester_player_index(0);
    *t.mutable_suspect() = s;
    *t.mutable_weapon() = w;
    *t.mutable_room() = r;
    t.set_responder_player_index(2); // P2 responded. P1 must have passed.

    engine.record_turn(t);
    GameStateResponse state = engine.get_game_state_response();

    // P1 Passed, so P1 must NOT have any of these
    EXPECT_EQ(get_status(state, 1, CardType::CARD_TYPE_SUSPECT, SUSPECT_MISS_SCARLET), CellState::DOES_NOT_HAVE);

    // P2 Responded, so P2 has "at least one", but we don't know which yet
    EXPECT_EQ(get_status(state, 2, CardType::CARD_TYPE_SUSPECT, SUSPECT_MISS_SCARLET), CellState::UNKNOWN);
}

TEST_F(GameEngineTest, KnownShow) {
    Card s = create_suspect(SUSPECT_MISS_SCARLET);
    Card w = create_weapon(WEAPON_ROPE);
    Card r = create_room(ROOM_HALL);

    // P1 shows us (P0) the Rope
    TurnData t;
    t.set_suggester_player_index(0);
    *t.mutable_suspect() = s;
    *t.mutable_weapon() = w;
    *t.mutable_room() = r;
    t.set_responder_player_index(1);
    *t.mutable_card_shown() = w;

    engine.record_turn(t);
    GameStateResponse state = engine.get_game_state_response();

    EXPECT_EQ(get_status(state, 1, CardType::CARD_TYPE_WEAPON, WEAPON_ROPE), CellState::HAS);
}

TEST_F(GameEngineTest, ConstraintResolution) {
    Card s = create_suspect(SUSPECT_MISS_SCARLET);
    Card w = create_weapon(WEAPON_ROPE);
    Card r = create_room(ROOM_HALL);

    // 1. P0 Suggests, P1 Shows (Unknown)
    TurnData t1;
    t1.set_suggester_player_index(0);
    *t1.mutable_suspect() = s;
    *t1.mutable_weapon() = w;
    *t1.mutable_room() = r;
    t1.set_responder_player_index(1);

    engine.record_turn(t1);

    // 2. Learn P1 !Scarlet (via pass)
    // P2 Suggests (Scarlet, Pipe, Lounge), P1 Passes
    TurnData t2;
    t2.set_suggester_player_index(0); // Using 0 as proxy for external observation or 0 observing P2->?->?
    // Wait, if P2 suggests and P1 passes.
    // Suggester 2. Responder 0. Path 2->0. P1 NOT involved?
    // 3 players: 0,1,2.
    // 2->0 is direct.
    // To make P1 pass, we need Suggester=0, Responder=2 (0->1->2). P1 passes.
    t2.set_suggester_player_index(0);
    *t2.mutable_suspect() = create_suspect(SUSPECT_MISS_SCARLET);
    *t2.mutable_weapon() = create_weapon(WEAPON_LEAD_PIPE);
    *t2.mutable_room() = create_room(ROOM_LOUNGE);
    t2.set_responder_player_index(2);

    engine.record_turn(t2);

    GameStateResponse state = engine.get_game_state_response();
    EXPECT_EQ(get_status(state, 1, CardType::CARD_TYPE_SUSPECT, SUSPECT_MISS_SCARLET), CellState::DOES_NOT_HAVE);

    // 3. Learn P1 !Rope
    TurnData t3;
    t3.set_suggester_player_index(0);
    *t3.mutable_suspect() = create_suspect(SUSPECT_PROF_PLUM);
    *t3.mutable_weapon() = create_weapon(WEAPON_ROPE);
    *t3.mutable_room() = create_room(ROOM_STUDY);
    t3.set_responder_player_index(2); // P1 passes again

    engine.record_turn(t3);
    state = engine.get_game_state_response();

    EXPECT_EQ(get_status(state, 1, CardType::CARD_TYPE_WEAPON, WEAPON_ROPE), CellState::DOES_NOT_HAVE);

    // Constraint reduced to: P1 has Hall.
    EXPECT_EQ(get_status(state, 1, CardType::CARD_TYPE_ROOM, ROOM_HALL), CellState::HAS);
}

// --- Event Sourcing Tests ---

class EventSourcingTest : public ::testing::Test {
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

TEST_F(EventSourcingTest, RecordAndReplay) {
    // 1. Record a turn: P0 Suggests (Mustard, Knife, Hall) -> P1 Passes -> P2 Shows
    TurnData t1;
    t1.set_suggester_player_index(0);
    *t1.mutable_suspect() = create_suspect(SUSPECT_COL_MUSTARD);
    *t1.mutable_weapon() = create_weapon(WEAPON_KNIFE);
    *t1.mutable_room() = create_room(ROOM_HALL);
    t1.set_responder_player_index(2); // P1 passed, P2 responded
    // No card shown

    engine.record_turn(t1);

    // Verify history
    EXPECT_EQ(engine.get_history().size(), 1);

    // Verify state: P1 passed, so !Mustard
    GameStateResponse state = engine.get_game_state_response();
    EXPECT_EQ(get_status(state, 1, CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD), CellState::DOES_NOT_HAVE);

    // 2. Update Turn: Change responder to P1 (so P1 did NOT pass)
    TurnData t1_new = t1;
    t1_new.set_responder_player_index(1); // P1 responded immediately

    std::string turn_id = engine.get_history()[0].turn_id();
    bool success = engine.update_turn(turn_id, t1_new);
    EXPECT_TRUE(success);

    // Verify P1 is NO LONGER known false for Mustard
    state = engine.get_game_state_response();
    EXPECT_NE(get_status(state, 1, CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD), CellState::DOES_NOT_HAVE);

    // 3. Add constraint logic to verify replay works
    // P1 responded to (Mustard, Knife, Hall). P1 has ONE of them.
    // Record turn 2: P1 passes on (Plum, Knife, Hall). So P1 !Knife, P1 !Hall.
    TurnData t2;
    t2.set_suggester_player_index(0);
    *t2.mutable_suspect() = create_suspect(SUSPECT_PROF_PLUM);
    *t2.mutable_weapon() = create_weapon(WEAPON_KNIFE);
    *t2.mutable_room() = create_room(ROOM_HALL);
    t2.set_responder_player_index(2); // P1 passed

    engine.record_turn(t2);

    // Logic: P1 passed on t2 -> !Knife, !Hall.
    // Constraint from t1 (Replayed): P1 has (Mustard OR Knife OR Hall).
    // Result: P1 MUST have Mustard.
    state = engine.get_game_state_response();
    EXPECT_EQ(get_status(state, 1, CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD), CellState::HAS);
}

TEST_F(EventSourcingTest, UndoTurn) {
    TurnData t1;
    t1.set_suggester_player_index(0);
    *t1.mutable_suspect() = create_suspect(SUSPECT_COL_MUSTARD);
    *t1.mutable_weapon() = create_weapon(WEAPON_KNIFE);
    *t1.mutable_room() = create_room(ROOM_HALL);
    t1.set_responder_player_index(1);

    engine.record_turn(t1);
    EXPECT_EQ(engine.get_history().size(), 1);

    engine.undo_last_turn();
    EXPECT_EQ(engine.get_history().size(), 0);
}
