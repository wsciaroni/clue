#include <clue/player.h>

#include <gtest/gtest.h>

TEST(PlayerTest, Name) {
    Clue::Player p;

    EXPECT_EQ(p.getName(), "");

    p.setName("Will");

    EXPECT_EQ(p.getName(), "Will");
}

TEST(PlayerTest, PlayerId) {
    Clue::Player p;

    EXPECT_FALSE(p.isMaster());
    p.setPlayerId(Clue::PlayerId::PLAYER_0);
    EXPECT_TRUE(p.isMaster());
}

TEST(PlayerTest, solveHand) {
    Clue::Player p;

    p.setNumCardsInHand(3);
    EXPECT_EQ(p.getNumCardsInHand(), 3);

    EXPECT_FALSE(p.isPlayerSolved());

    Clue::Card c = Clue::Card::MISS_SCARLET;
    EXPECT_FALSE(p.hasCard(c));
    p.addCardToHand(c);
    EXPECT_TRUE(p.hasCard(c));

    EXPECT_FALSE(p.isPlayerSolved());

    c = Clue::Card::CANDLESTICK;
    EXPECT_FALSE(p.hasCard(c));
    p.addCardToHand(c);
    EXPECT_TRUE(p.hasCard(c));

    EXPECT_FALSE(p.isPlayerSolved());

    c = Clue::Card::KITCHEN;
    EXPECT_FALSE(p.hasCard(c));
    p.addCardToHand(c);
    EXPECT_TRUE(p.hasCard(c));

    EXPECT_TRUE(p.isPlayerSolved());

    // Exhaustively check to make sure that each of the cards have been updated on the player
    for(Clue::Card i = Clue::Card::FIRST; i < Clue::Card::LAST; ++i) {
        if(i != Clue::Card::MISS_SCARLET && i != Clue::Card::CANDLESTICK && i != Clue::Card::KITCHEN){
            EXPECT_TRUE(p.doesntHaveCard(i));
            EXPECT_FALSE(p.hasCard(i));
        } else {
            EXPECT_FALSE(p.doesntHaveCard(i));
            EXPECT_TRUE(p.hasCard(i));
        }
    }
}

TEST(PlayerTest, ExclusionLogic) {
    Clue::Player p;
    p.cardDefinitelyNotInHand(Clue::Card::MISS_SCARLET);
    p.cardDefinitelyNotInHand(Clue::Card::CANDLESTICK);
    EXPECT_FALSE(p.hasCard(Clue::Card::KITCHEN));
    p.showedOneOfThese(Clue::Suspect::MISS_SCARLET, Clue::Weapon::CANDLESTICK, Clue::Room::KITCHEN);
    EXPECT_TRUE(p.hasCard(Clue::Card::KITCHEN));
}

TEST(PlayerTest, NotInHand) {
    Clue::Player p;

    std::set<Clue::Card> st;

    EXPECT_EQ(*(p.getNotInHand()), st);

    p.cardDefinitelyNotInHand(Clue::Card::MISS_SCARLET);

    st.insert(Clue::Card::MISS_SCARLET);

    EXPECT_EQ(*(p.getNotInHand()), st);
}

TEST(PlayerTest, InHand) {
    Clue::Player p;

    std::set<Clue::Card> st;

    EXPECT_EQ(*(p.getHand()), st);
    EXPECT_FALSE(p.hasCard(Clue::Card::MISS_SCARLET));
    p.addCardToHand(Clue::Card::MISS_SCARLET);
    EXPECT_TRUE(p.hasCard(Clue::Card::MISS_SCARLET));
    st.insert(Clue::Card::MISS_SCARLET);
    EXPECT_EQ(*(p.getHand()), st);

    EXPECT_FALSE(p.isPlayerSolved());
}