#include <gtest/gtest.h>
#include "ClueSolver.h"
#include "Types.h"
#include "clue.pb.h"
#include <vector>

using namespace clue;

// Helper to create a card
Card create_card(CardType type, int id) {
    Card c;
    c.set_type(type);
    if (type == CardType::CARD_TYPE_SUSPECT) c.set_suspect((Suspect)id);
    else if (type == CardType::CARD_TYPE_WEAPON) c.set_weapon((Weapon)id);
    else if (type == CardType::CARD_TYPE_ROOM) c.set_room((Room)id);
    return c;
}

// Tests the specific logic requested:
// "If we know one of the answers (e.g. Candlestick is Case File)
//  AND we know 3 out of 4 players don't have the Lead Pipe,
//  Then we know the last player definitely has the Lead Pipe."
TEST(ClueSolverTest, TestDeducePlayerHasCardWhenOtherIsCaseFile) {
    // Setup 4 players (Indices 0, 1, 2, 3)
    int num_players = 4;
    std::vector<Card> my_hand; // Empty hand for simplicity, or irrelevant cards
    std::vector<int> card_counts = {3, 3, 3, 3}; // Placeholder counts

    ClueSolver solver;
    solver.initialize(num_players, my_hand, card_counts);

    // Card Constants
    // Weapon 2: Candlestick
    // Weapon 5: Lead Pipe
    Card candlestick = create_card(CardType::CARD_TYPE_WEAPON, Weapon::WEAPON_CANDLESTICK);
    Card lead_pipe = create_card(CardType::CARD_TYPE_WEAPON, Weapon::WEAPON_LEAD_PIPE);
    Card some_suspect = create_card(CardType::CARD_TYPE_SUSPECT, Suspect::SUSPECT_COL_MUSTARD);
    Card some_room = create_card(CardType::CARD_TYPE_ROOM, Room::ROOM_HALL);

    int candlestick_idx = ClueSolver::get_card_index(candlestick);
    int lead_pipe_idx = ClueSolver::get_card_index(lead_pipe);
    int p3_idx = 3; // The "last" player

    // 1. Establish that Candlestick is in the Case File.
    // We can simulate this by having all players (0, 1, 2, 3) pass on it.
    // Turn: Suggester 0 asks for {Mustard, Candlestick, Hall}.
    // Responders 1, 2, 3 pass.
    // Suggester (0) also doesn't show (implied).
    // Actually, update_belief_pass sets prob to 0 for the player passed.
    // If we call it for all players, Case File prob should go to 1.

    // Everyone passes on Candlestick
    for (int p = 0; p < num_players; ++p) {
        // We use update_belief_pass directly or via process_turn.
        // process_turn requires a TurnData.
        // Let's create a turn where everyone passes.
        // But process_turn structure implies one suggester and sequence of passers.
        // We can just manually call update_belief_pass via a friend/helper or public method?
        // update_belief_pass is private. We should use process_turn.

        // To make everyone pass on Candlestick, we need multiple turns or a specific scenario.
        // E.g. P0 asks P1..3, no one answers.
        // TurnData: suggester=0, suspect=Mustard, weapon=Candlestick, room=Hall, responder=-1.
        // This means 1, 2, 3 passed.
        // What about 0? 0 is suggester. 0 might have it?
        // If 0 suggests it, usually 0 doesn't have it (unless bluffing).
        // But the solver tracks 0's hand as "Known". If 0 doesn't have it in my_hand, P(Candlestick, 0) is already 0.
    }

    // Step 1: Ensure Candlestick is Case File.
    // My hand is empty, so P(Candlestick, 0) = 0.
    // Turn 1: P0 asks P1, P2, P3. None respond.
    TurnData t1;
    t1.set_suggester_player_index(0);
    *t1.mutable_suspect() = some_suspect;
    *t1.mutable_weapon() = candlestick;
    *t1.mutable_room() = some_room;
    t1.set_responder_player_index(-1); // No one responded

    solver.process_turn(t1, card_counts);

    // Verify Candlestick is considered Case File
    // P(Candlestick, CF) should be 1.0.
    float p_candlestick_cf = solver.get_probability(candlestick_idx, num_players);
    EXPECT_NEAR(p_candlestick_cf, 1.0f, 0.001f);

    // 2. Establish that Lead Pipe is NOT held by P0, P1, P2.
    // "We know 3 out of 4 players don't have the lead pipe".
    // Let's say P0, P1, P2 don't have it.
    // Since I am P0 and hand is empty, P(Lead Pipe, P0) is 0.
    // We need P1 and P2 to pass on Lead Pipe.

    // Turn 2: P0 asks P1, P2 about Lead Pipe. P3 responds?
    // If P3 responds, we know P3 has *one* of S, W, R. Not necessarily Lead Pipe.
    // But the prompt says "We know P1, P2, P4 don't have Lead Pipe".
    // Implies we definitely know they don't.
    // This happens if they pass.

    // So let's have P1 and P2 pass on Lead Pipe.
    // Turn: P0 asks {Mustard, Lead Pipe, Hall}. P1 passes. P2 passes.
    // Responder is P3 (or -1).
    // Let's say responder is P3. So P1 and P2 passed.
    TurnData t2;
    t2.set_suggester_player_index(0);
    *t2.mutable_suspect() = some_suspect;
    *t2.mutable_weapon() = lead_pipe;
    *t2.mutable_room() = some_room;
    t2.set_responder_player_index(3); // P3 responds

    // Note: process_turn will mark P1 and P2 as not having Lead Pipe.
    solver.process_turn(t2, card_counts);

    // Check intermediate state
    // P(Lead Pipe, P1) should be 0.
    // P(Lead Pipe, P2) should be 0.
    EXPECT_NEAR(solver.get_probability(lead_pipe_idx, 1), 0.0f, 0.001f);
    EXPECT_NEAR(solver.get_probability(lead_pipe_idx, 2), 0.0f, 0.001f);

    // P(Lead Pipe, CF) should be 0 because Candlestick IS the Case File weapon.
    // THIS IS THE MISSING LOGIC.
    // Currently, the solver does not enforce "Only 1 Weapon in Case File".
    // So P(Lead Pipe, CF) is likely still non-zero (it started as 1/6).
    // Because of that, P(Lead Pipe, P3) will not be 1.0. It will share probability with CF.

    float p_lead_pipe_p3 = solver.get_probability(lead_pipe_idx, 3);
    float p_lead_pipe_cf = solver.get_probability(lead_pipe_idx, num_players);

    std::cout << "P(Lead Pipe, P3) = " << p_lead_pipe_p3 << std::endl;
    std::cout << "P(Lead Pipe, CF) = " << p_lead_pipe_cf << std::endl;

    // Expectation: P(Lead Pipe, P3) SHOULD be 1.0 if logic was correct.
    // But we expect failure now.
    EXPECT_NEAR(p_lead_pipe_p3, 1.0f, 0.001f);
    EXPECT_NEAR(p_lead_pipe_cf, 0.0f, 0.001f);
}
