#include <clue/turn.h>

#include <gtest/gtest.h>

TEST(TurnTest, DefaultInitializer) {
    Clue::Turn t;
    EXPECT_FALSE(t.getIsMyTurn());
    EXPECT_FALSE(t.getIAnswered());

    EXPECT_EQ(t.getPlayersTurn(), nullptr);

    std::set<std::shared_ptr<Clue::Player>> s;
    EXPECT_EQ(t.getPlayersWithoutCards(), s);

    EXPECT_EQ(t.getAccusationSuspect(), Clue::Suspect::NONE);
    EXPECT_EQ(t.getAccusationWeapon(),Clue::Weapon::NONE);
    EXPECT_EQ(t.getAccusationRoom(),Clue::Room::NONE);

    EXPECT_EQ(t.getPlayerAnswered(), nullptr);

    EXPECT_EQ(t.getCardShown(), Clue::Card::NONE);
}

class TurnTestF : public ::testing::Test {
protected:
    std::shared_ptr<Clue::Player> p0 = std::make_shared<Clue::Player>();
    std::shared_ptr<Clue::Player> p1 = std::make_shared<Clue::Player>();
    std::shared_ptr<Clue::Player> p2 = std::make_shared<Clue::Player>();
    std::shared_ptr<Clue::Player> p3 = std::make_shared<Clue::Player>();

    std::set<std::shared_ptr<Clue::Player>> playersWithoutCardsSet;

    void SetUp() override {
        p0->setPlayerId(Clue::PlayerId::PLAYER_0);
        p1->setPlayerId(Clue::PlayerId::PLAYER_1);
        p2->setPlayerId(Clue::PlayerId::PLAYER_2);
        p3->setPlayerId(Clue::PlayerId::PLAYER_3);
    }

    void TearDown() override {}
};

TEST_F(TurnTestF, FirstPlayerAnswers) {
// By default, we don't know anyone's cards
    EXPECT_FALSE(p1->hasCard(Clue::Card::MISS_SCARLET));

    Clue::Turn t(
        p0,
        true,
        Clue::Suspect::MISS_SCARLET,
        Clue::Weapon::CANDLESTICK,
        Clue::Room::KITCHEN,
        p1,
        Clue::Card::MISS_SCARLET,
        playersWithoutCardsSet
    );
    t.executeTurn();
    EXPECT_TRUE(t.getIsMyTurn());
    EXPECT_FALSE(t.getIAnswered());
    EXPECT_EQ(t.getPlayersTurn(), p0);
    EXPECT_TRUE(t.getPlayersWithoutCards().empty());

    EXPECT_EQ(t.getAccusationSuspect(), Clue::Suspect::MISS_SCARLET);
    EXPECT_EQ(t.getAccusationWeapon(),Clue::Weapon::CANDLESTICK);
    EXPECT_EQ(t.getAccusationRoom(),Clue::Room::KITCHEN);
    EXPECT_EQ(t.getPlayerAnswered(), p1);
    EXPECT_EQ(t.getCardShown(), Clue::Card::MISS_SCARLET);

// We should now know that P1 has MISS_SCARLET... She showed us that this turn
    EXPECT_TRUE(p1->hasCard(Clue::Card::MISS_SCARLET));
    EXPECT_TRUE(t.cardWasShownToMe());
    EXPECT_FALSE(t.iShowedACard());
}

TEST_F(TurnTestF, SecondPlayerAnswers) {
// By default, we don't know anyone's cards
    EXPECT_FALSE(p2->hasCard(Clue::Card::MISS_SCARLET));

// We haven't eliminated these cards from p1's hand yet
    EXPECT_FALSE(p1->doesntHaveCard(Clue::Card::MISS_SCARLET));

    playersWithoutCardsSet.insert(p1);
    Clue::Turn t(
        p0,
        true,
        Clue::Suspect::MISS_SCARLET,
        Clue::Weapon::CANDLESTICK,
        Clue::Room::KITCHEN,
        p2,
        Clue::Card::MISS_SCARLET,
        playersWithoutCardsSet
    );
    t.executeTurn();
    EXPECT_TRUE(t.getIsMyTurn());
    EXPECT_FALSE(t.getIAnswered());
    EXPECT_EQ(t.getPlayersTurn(), p0);
    EXPECT_EQ(t.getPlayersWithoutCards(), playersWithoutCardsSet);

    EXPECT_EQ(t.getAccusationSuspect(), Clue::Suspect::MISS_SCARLET);
    EXPECT_EQ(t.getAccusationWeapon(),Clue::Weapon::CANDLESTICK);
    EXPECT_EQ(t.getAccusationRoom(),Clue::Room::KITCHEN);
    EXPECT_EQ(t.getPlayerAnswered(), p2);
    EXPECT_EQ(t.getCardShown(), Clue::Card::MISS_SCARLET);

// We should now know that P2 has MISS_SCARLET... She showed us that this turn
    EXPECT_TRUE(p2->hasCard(Clue::Card::MISS_SCARLET));

// We now know, p1 does not have any of these 3 cards:
    EXPECT_TRUE(p1->doesntHaveCard(Clue::Card::MISS_SCARLET));
    EXPECT_TRUE(p1->doesntHaveCard(Clue::Card::CANDLESTICK));
    EXPECT_TRUE(p1->doesntHaveCard(Clue::Card::KITCHEN));

    auto s = t.toString();
}

TEST_F(TurnTestF, OtherPlayerAnswers) {
    playersWithoutCardsSet.insert(p2);
    Clue::Turn t(
        p1,
        true,
        Clue::Suspect::MISS_SCARLET,
        Clue::Weapon::CANDLESTICK,
        Clue::Room::KITCHEN,
        p3,
        Clue::Card::INVALID,
        playersWithoutCardsSet
    );
    t.executeTurn();
    EXPECT_FALSE(t.getIsMyTurn());
    EXPECT_FALSE(t.getIAnswered());
    EXPECT_EQ(t.getPlayersTurn(), p1);
    EXPECT_EQ(t.getPlayersWithoutCards(), playersWithoutCardsSet);

    EXPECT_EQ(t.getAccusationSuspect(), Clue::Suspect::MISS_SCARLET);
    EXPECT_EQ(t.getAccusationWeapon(),Clue::Weapon::CANDLESTICK);
    EXPECT_EQ(t.getAccusationRoom(),Clue::Room::KITCHEN);
    EXPECT_EQ(t.getPlayerAnswered(), p3);
    EXPECT_EQ(t.getCardShown(), Clue::Card::INVALID);

// We now know, p1 does not have any of these 3 cards:
    EXPECT_TRUE(p2->doesntHaveCard(Clue::Card::MISS_SCARLET));
    EXPECT_TRUE(p2->doesntHaveCard(Clue::Card::CANDLESTICK));
    EXPECT_TRUE(p2->doesntHaveCard(Clue::Card::KITCHEN));
}

TEST_F(TurnTestF, OtherPlayerNoOneAnswers) {
    playersWithoutCardsSet.insert(p0);
    playersWithoutCardsSet.insert(p2);
    playersWithoutCardsSet.insert(p3);
    Clue::Turn t(
        p1,
        true,
        Clue::Suspect::MISS_SCARLET,
        Clue::Weapon::CANDLESTICK,
        Clue::Room::KITCHEN,
        p1,
        Clue::Card::INVALID,
        playersWithoutCardsSet
    );
    t.executeTurn();
    EXPECT_FALSE(t.getIsMyTurn());
    EXPECT_FALSE(t.getIAnswered());
    EXPECT_EQ(t.getPlayersTurn(), p1);
    EXPECT_EQ(t.getPlayersWithoutCards(), playersWithoutCardsSet);

    EXPECT_EQ(t.getAccusationSuspect(), Clue::Suspect::MISS_SCARLET);
    EXPECT_EQ(t.getAccusationWeapon(),Clue::Weapon::CANDLESTICK);
    EXPECT_EQ(t.getAccusationRoom(),Clue::Room::KITCHEN);
    EXPECT_EQ(t.getPlayerAnswered(), p1);
    EXPECT_EQ(t.getCardShown(), Clue::Card::INVALID);

// We now know, p1 does not have any of these 3 cards:
    EXPECT_TRUE(p2->doesntHaveCard(Clue::Card::MISS_SCARLET));
    EXPECT_TRUE(p2->doesntHaveCard(Clue::Card::CANDLESTICK));
    EXPECT_TRUE(p2->doesntHaveCard(Clue::Card::KITCHEN));

    EXPECT_TRUE(p3->doesntHaveCard(Clue::Card::MISS_SCARLET));
    EXPECT_TRUE(p3->doesntHaveCard(Clue::Card::CANDLESTICK));
    EXPECT_TRUE(p3->doesntHaveCard(Clue::Card::KITCHEN));

    EXPECT_TRUE(p0->doesntHaveCard(Clue::Card::MISS_SCARLET));
    EXPECT_TRUE(p0->doesntHaveCard(Clue::Card::CANDLESTICK));
    EXPECT_TRUE(p0->doesntHaveCard(Clue::Card::KITCHEN));

    auto s = t.toString();
}

TEST_F(TurnTestF, OtherPlayerNoAccusation) {
    Clue::Turn t(
        p1,
        false,
        Clue::Suspect::NONE,
        Clue::Weapon::NONE,
        Clue::Room::NONE,
        p1,
        Clue::Card::NONE,
        playersWithoutCardsSet
    );
    t.executeTurn();
    EXPECT_FALSE(t.getIsMyTurn());
    EXPECT_FALSE(t.getIAnswered());
    EXPECT_EQ(t.getPlayersTurn(), p1);
    EXPECT_EQ(t.getPlayersWithoutCards(), playersWithoutCardsSet);

    EXPECT_EQ(t.getAccusationSuspect(), Clue::Suspect::NONE);
    EXPECT_EQ(t.getAccusationWeapon(),Clue::Weapon::NONE);
    EXPECT_EQ(t.getAccusationRoom(),Clue::Room::NONE);
    EXPECT_EQ(t.getPlayerAnswered(), p1);
    EXPECT_EQ(t.getCardShown(), Clue::Card::NONE);
}

TEST_F(TurnTestF, MeNoAccusation) {
    Clue::Turn t(
        p0,
        false,
        Clue::Suspect::NONE,
        Clue::Weapon::NONE,
        Clue::Room::NONE,
        p0,
        Clue::Card::NONE,
        playersWithoutCardsSet
    );
    t.executeTurn();
    EXPECT_TRUE(t.getIsMyTurn());
    EXPECT_FALSE(t.getIAnswered());
    EXPECT_EQ(t.getPlayersTurn(), p0);
    EXPECT_EQ(t.getPlayersWithoutCards(), playersWithoutCardsSet);

    EXPECT_EQ(t.getAccusationSuspect(), Clue::Suspect::NONE);
    EXPECT_EQ(t.getAccusationWeapon(),Clue::Weapon::NONE);
    EXPECT_EQ(t.getAccusationRoom(),Clue::Room::NONE);
    EXPECT_EQ(t.getPlayerAnswered(), p0);
    EXPECT_EQ(t.getCardShown(), Clue::Card::NONE);

    EXPECT_FALSE(t.cardWasShownToMe());
    EXPECT_FALSE(t.iShowedACard());
}

TEST_F(TurnTestF, MeShowP3) {
    p1->addCardToHand(Clue::Card::MISS_SCARLET);
    playersWithoutCardsSet.insert(p3);
    Clue::Turn t(
        p2,
        true,
        Clue::Suspect::MISS_SCARLET,
        Clue::Weapon::CANDLESTICK,
        Clue::Room::KITCHEN,
        p0,
        Clue::Card::MISS_SCARLET,
        playersWithoutCardsSet
    );
    t.executeTurn();
    EXPECT_FALSE(t.getIsMyTurn());
    EXPECT_TRUE(t.getIAnswered());
    EXPECT_EQ(t.getPlayersTurn(), p2);
    EXPECT_EQ(t.getPlayersWithoutCards(), playersWithoutCardsSet);

    EXPECT_EQ(t.getAccusationSuspect(), Clue::Suspect::MISS_SCARLET);
    EXPECT_EQ(t.getAccusationWeapon(),Clue::Weapon::CANDLESTICK);
    EXPECT_EQ(t.getAccusationRoom(),Clue::Room::KITCHEN);
    EXPECT_EQ(t.getPlayerAnswered(), p0);
    EXPECT_EQ(t.getCardShown(), Clue::Card::MISS_SCARLET);

    auto s = t.toString();

    EXPECT_FALSE(t.cardWasShownToMe());
    EXPECT_TRUE(t.iShowedACard());
}