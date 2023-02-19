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

    Clue::Card c = Clue::Card::MISS_SCARLET;
    EXPECT_FALSE(p.hasCard(c));
    p.addCardToHand(c);
    EXPECT_TRUE(p.hasCard(c));

    c = Clue::Card::CANDLESTICK;
    EXPECT_FALSE(p.hasCard(c));
    p.addCardToHand(c);
    EXPECT_TRUE(p.hasCard(c));

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