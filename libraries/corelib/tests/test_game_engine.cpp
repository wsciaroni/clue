#include <gtest/gtest.h>
#include "GameEngine.h"

using namespace clue;

// Helper to create cards
Card create_suspect(Suspect s) {
    Card c;
    c.set_type(CardType::CARD_TYPE_SUSPECT);
    c.set_suspect(s);
    return c;
}

Card create_weapon(Weapon w) {
    Card c;
    c.set_type(CardType::CARD_TYPE_WEAPON);
    c.set_weapon(w);
    return c;
}

Card create_room(Room r) {
    Card c;
    c.set_type(CardType::CARD_TYPE_ROOM);
    c.set_room(r);
    return c;
}

TEST(GameEngineTest, Initialization) {
    GameEngine engine;
    std::vector<Card> my_hand = {
        create_suspect(SUSPECT_COL_MUSTARD),
        create_weapon(WEAPON_KNIFE)
    };

    // Initialize 3 players
    engine.initialize(3, my_hand);

    // Check my hand (Player 0)
    CardId mustard = {CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD};
    EXPECT_EQ(engine.get_card_state(0, mustard), CardState::KNOWN_TRUE);

    // Check others don't have it
    EXPECT_EQ(engine.get_card_state(1, mustard), CardState::KNOWN_FALSE);
    EXPECT_EQ(engine.get_case_file_state(mustard), CardState::KNOWN_FALSE);

    // Check unknown card
    CardId plum = {CardType::CARD_TYPE_SUSPECT, SUSPECT_PROF_PLUM};
    EXPECT_EQ(engine.get_card_state(0, plum), CardState::KNOWN_FALSE); // I don't have it (not in my hand)
    EXPECT_EQ(engine.get_card_state(1, plum), CardState::UNKNOWN);
}

TEST(GameEngineTest, SimplePassLogic) {
    GameEngine engine;
    engine.initialize(3, {}); // Empty hand for simplicity

    Card s = create_suspect(SUSPECT_COL_MUSTARD);
    Card w = create_weapon(WEAPON_KNIFE);
    Card r = create_room(ROOM_HALL);

    // P0 Suggests, P1 Passes, P2 Responds
    // P0 index 0, P1 index 1, P2 index 2
    engine.process_suggestion(0, s, w, r, 2, std::nullopt);

    CardId s_id = {CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD};

    // P1 Passed, so P1 must NOT have any of these
    EXPECT_EQ(engine.get_card_state(1, s_id), CardState::KNOWN_FALSE);

    // P2 Responded, so P2 has "at least one", but we don't know which yet
    EXPECT_EQ(engine.get_card_state(2, s_id), CardState::UNKNOWN);
}

TEST(GameEngineTest, KnownShow) {
    GameEngine engine;
    engine.initialize(3, {});

    Card s = create_suspect(SUSPECT_COL_MUSTARD);
    Card w = create_weapon(WEAPON_KNIFE);
    Card r = create_room(ROOM_HALL);

    // P1 shows us (P0) the Knife
    engine.process_suggestion(0, s, w, r, 1, w);

    CardId w_id = {CardType::CARD_TYPE_WEAPON, WEAPON_KNIFE};
    EXPECT_EQ(engine.get_card_state(1, w_id), CardState::KNOWN_TRUE);
}

TEST(GameEngineTest, ConstraintResolution) {
    GameEngine engine;
    engine.initialize(3, {});

    Card s = create_suspect(SUSPECT_COL_MUSTARD);
    Card w = create_weapon(WEAPON_KNIFE);
    Card r = create_room(ROOM_HALL);

    CardId s_id = {CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD};
    CardId w_id = {CardType::CARD_TYPE_WEAPON, WEAPON_KNIFE};
    CardId r_id = {CardType::CARD_TYPE_ROOM, ROOM_HALL};

    // 1. P0 Suggests, P1 Shows (Unknown)
    // Constraint: P1 has (Mustard OR Knife OR Hall)
    engine.process_suggestion(0, s, w, r, 1, std::nullopt);

    // 2. Later, we learn P1 does NOT have Mustard (maybe P2 showed it to us later, or P1 passed on a suggestion involving Mustard)
    // Let's simulate we found out P1 doesn't have Mustard via a pass
    // P2 Suggests (Mustard, Rope, Lounge), P1 Passes
    engine.process_suggestion(2,
                              create_suspect(SUSPECT_COL_MUSTARD),
                              create_weapon(WEAPON_ROPE),
                              create_room(ROOM_LOUNGE),
                              0, std::nullopt); // P1 passed (responder 0 means P1 passed, P2->0->1... wait. 2->0 is P0. )

    // Wait, process_suggestion logic for passes:
    // suggester=2. responder=0.
    // Order: 2 -> 0.
    // The player "between" 2 and 0 is... none?
    // 3 players: 0, 1, 2.
    // 2->0. clockwise: 2 -> 0. (1 is skipped? No. 2->0 is adjacent).
    // Let's force P1 to pass explicitly.
    // Suggester P2. Responder P0.
    // Path: 2 -> 0.
    // Does 1 pass?
    // 2 -> 0. Clockwise: 2 -> 0. P1 is NOT between them.

    // Let's use direct forcing for test clarity
    // P0 Suggests (Mustard, Rope, Lounge), P2 Responds. P1 Passed.
    // Suggester 0. Responder 2. Path: 0->1->2. P1 passed.
    engine.process_suggestion(0,
                             create_suspect(SUSPECT_COL_MUSTARD),
                             create_weapon(WEAPON_ROPE),
                             create_room(ROOM_LOUNGE),
                             2, std::nullopt);

    // Now P1 is known NOT to have Mustard.
    EXPECT_EQ(engine.get_card_state(1, s_id), CardState::KNOWN_FALSE);

    engine.reconcile(); // Run solver

    // Original Constraint: P1 has (Mustard OR Knife OR Hall)
    // New Info: P1 !Mustard.
    // Constraint becomes: P1 has (Knife OR Hall).

    // Let's eliminate Knife too.
    // P0 Suggests (Plum, Knife, Study). P2 Responds. P1 Passed.
    engine.process_suggestion(0,
                              create_suspect(SUSPECT_PROF_PLUM),
                              create_weapon(WEAPON_KNIFE),
                              create_room(ROOM_STUDY),
                              2, std::nullopt);

    // Now P1 !Knife.
    EXPECT_EQ(engine.get_card_state(1, w_id), CardState::KNOWN_FALSE);

    engine.reconcile();

    // Constraint reduced to: P1 has Hall.
    // So P1 MUST have Hall.
    EXPECT_EQ(engine.get_card_state(1, r_id), CardState::KNOWN_TRUE);
}

TEST(GameEngineTest, CaseFileSolver) {
    GameEngine engine;
    engine.initialize(3, {}); // 3 players

    CardId s_id = {CardType::CARD_TYPE_SUSPECT, SUSPECT_COL_MUSTARD};

    // Mark Mustard FALSE for everyone
    engine.process_suggestion(1, create_suspect(SUSPECT_COL_MUSTARD), create_weapon(WEAPON_KNIFE), create_room(ROOM_HALL), 0, std::nullopt);
    // 1->0 path includes 2. P2 passed Mustard.

    // Need to explicitly mark P0, P1, P2 false for Mustard.
    // Hack: Use internal knowledge or clever suggestions.

    // P0 (us) doesn't have it (initially known false if not in hand).
    EXPECT_EQ(engine.get_card_state(0, s_id), CardState::KNOWN_FALSE);

    // P1 passes on Mustard
    engine.process_suggestion(2, create_suspect(SUSPECT_COL_MUSTARD), create_weapon(WEAPON_ROPE), create_room(ROOM_LOUNGE), 0, std::nullopt);
    // 2->0. P1 not involved? Wait. 3 players: 0, 1, 2.
    // 2->0 is direct.
    // 0->2 passes 1.
    engine.process_suggestion(0, create_suspect(SUSPECT_COL_MUSTARD), create_weapon(WEAPON_ROPE), create_room(ROOM_LOUNGE), 2, std::nullopt);
    // 0->1->2. P1 passes Mustard.
    EXPECT_EQ(engine.get_card_state(1, s_id), CardState::KNOWN_FALSE);

    // P2 passes on Mustard
    engine.process_suggestion(0, create_suspect(SUSPECT_COL_MUSTARD), create_weapon(WEAPON_ROPE), create_room(ROOM_LOUNGE), 1, std::nullopt);
    // 0->1. Responder is 1. No one passed?
    // Suggester 0. Responder 1. Interval: (0+1)..1 => empty?
    // Check logic: current = (0+1)%3 = 1. end=1. Loop while(1!=1) -> doesn't run. Correct.

    // Let's make P2 pass.
    // Suggester 1. Responder 0. Path 1->2->0. P2 passes.
    engine.process_suggestion(1, create_suspect(SUSPECT_COL_MUSTARD), create_weapon(WEAPON_ROPE), create_room(ROOM_LOUNGE), 0, std::nullopt);

    EXPECT_EQ(engine.get_card_state(2, s_id), CardState::KNOWN_FALSE);

    // Now P0, P1, P2 all !Mustard.
    engine.reconcile();

    // Case File MUST be Mustard.
    EXPECT_EQ(engine.get_case_file_state(s_id), CardState::KNOWN_TRUE);
}
