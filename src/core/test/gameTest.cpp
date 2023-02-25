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
    g.setWhoGoesFirst("Abby");
    g.createGame(names, hand);

    EXPECT_EQ(g.getNumberOfPlayers(), 3);
    EXPECT_NO_THROW(g.getPlayerByName("Will"));
    EXPECT_NO_THROW(g.getPlayerByName("Abby"));
    EXPECT_NO_THROW(g.getPlayerByName("Hokie"));
    EXPECT_THROW(g.getPlayerByName("BADPLAYER"), Clue::Game::PlayerNotFoundByName);
    try {
        g.getPlayerByName("BADPLAYER");
    } catch (Clue::Game::PlayerNotFoundByName& e) {
        std::cout << "PlayerNotFoundByName: " << e.what() << std::endl;
    }

    auto abby = g.whosTurnIsIt();
    EXPECT_STREQ(abby->getName().c_str(), "Abby");
    auto t0 = std::make_shared<Clue::Turn>(abby);
    EXPECT_NO_THROW(g.submitTurn(t0));

    auto hokie = g.getPlayerByName("Hokie");
    auto t1 = std::make_shared<Clue::Turn>(hokie);

    auto will = g.getPlayerByName("Will");
    auto t2 = std::make_shared<Clue::Turn>(will);

    // Try to supbit t2 out of order
    EXPECT_THROW(g.submitTurn(t2), std::logic_error);

    EXPECT_NO_THROW(g.submitTurn(t1));
    EXPECT_NO_THROW(g.submitTurn(t2));

    // Brought it back to Abby's turn
    EXPECT_EQ(g.whosTurnIsIt(), abby);

    std::set<std::shared_ptr<Clue::Player>> emptySetOfPlayers;

    auto t3 = std::make_shared<Clue::Turn>(
        abby,
        true,
        Clue::Suspect::MR_GREEN,
        Clue::Weapon::WRENCH,
        Clue::Room::BILLIARD_ROOM,
        hokie,
        Clue::Card::INVALID,
        emptySetOfPlayers
    );
    EXPECT_NO_THROW(g.submitTurn(t3));
    EXPECT_TRUE(hokie->hasCard(Clue::Card::BILLIARD_ROOM));
    EXPECT_TRUE(will->doesntHaveCard(Clue::Card::BILLIARD_ROOM));
    EXPECT_TRUE(abby->doesntHaveCard(Clue::Card::BILLIARD_ROOM));
}

TEST(GameTest, Getters) {
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
    g.setWhoGoesFirst("Will");
    g.createGame(names, hand);

    EXPECT_EQ(g.getNumberOfPlayers(), 3);

    g.getPlayersQStringListModel();
    g.getTurnsStringListModel();
    g.getSuspectsQStringListModel();
    g.getWeaponsQStringListModel();
    g.getRoomsQStringListModel();
    g.getCardQStringListModel();

    auto a = g.getPlayersBetween(g.getPlayerByName("Will"),g.getPlayerByName("Hokie"));
    EXPECT_EQ(a.size(),1);
    EXPECT_EQ(*a.begin(), g.getPlayerByName("Abby"));

    a = g.getPlayersBetween(g.getPlayerByName("Will"),g.getPlayerByName("Will"));
    EXPECT_EQ(a.size(), 2);
    EXPECT_EQ(*a.begin(), g.getPlayerByName("Abby"));
    EXPECT_EQ(*std::next(a.begin()), g.getPlayerByName("Hokie"));

    a = g.getPlayersBetween(g.getPlayerByName("Hokie"), g.getPlayerByName("Abby"));
    EXPECT_EQ(a.size(),1);
    EXPECT_EQ(*a.begin(), g.getPlayerByName("Will"));

    g.getWholePlayerListStrings();
    g.getTableInfo();
}