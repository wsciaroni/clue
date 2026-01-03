#include <gtest/gtest.h>

#include <clue/game.h>

#include <vector>
#include <string>

/*
 * Ficticious Game
 * Will (Me):
 * - CONSERVATORY
 * - DINING_ROOM
 * - LIBRARY
 * - MR_GREEN
 * - STUDY
 * - HALL
 * - WRENCH
 *
 * Abby:
 * - BALLROOM
 * - HALL
 * - DAGGER
 * - MISS_SCARLET
 * - MRS_WHITE
 * - REVOLVER
 *
 * Hokie:
 * - BILLIARD_ROOM
 * - CANDLESTICK
 * - COLONEL_MUSTARD
 * - KITCHEN
 * - LEAD_PIPE
 * - MRS_PEACOCK
 *
 * Correct Answer:
 * - PROFESSOR_PLUM
 * - ROPE
 * - LOUNGE
 */

TEST(GameTest, CreateGame) {
    std::vector<std::string> names = {
        "Will",
        "Abby",
        "Hokie"
    };

    std::set<Clue::Card> hand = {
        Clue::Card::CONSERVATORY,
        Clue::Card::DINING_ROOM,
        Clue::Card::LIBRARY,
        Clue::Card::MR_GREEN,
        Clue::Card::STUDY,
        Clue::Card::HALL,
        Clue::Card::WRENCH
    };

    Clue::Game g;
    g.createGame(names, hand);
}