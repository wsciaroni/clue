#include <clue/constants.h>

#include <gtest/gtest.h>

TEST(ConstantTests, NUMBERS) {
    EXPECT_EQ(Clue::NUMBER_OF_SUSPECTS, 6);
    EXPECT_EQ(Clue::NUMBER_OF_WEAPONS, 6);
    EXPECT_EQ(Clue::NUMBER_OF_ROOMS, 9);

    EXPECT_EQ(Clue::NUMBER_OF_CARDS, 21);
}

TEST(ConstantTests, TranslatorSuspect) {
    Clue::Suspect s = Clue::Suspect::NONE;
    Clue::Card c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::NONE);
    s = Clue::fromCard<Clue::Suspect>(c);
    EXPECT_EQ(s, Clue::Suspect::NONE);

    s = Clue::Suspect::MISS_SCARLET;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::MISS_SCARLET);
    s = Clue::fromCard<Clue::Suspect>(c);
    EXPECT_EQ(s, Clue::Suspect::MISS_SCARLET);

    s = Clue::Suspect::COLONEL_MUSTARD;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::COLONEL_MUSTARD);
    s = Clue::fromCard<Clue::Suspect>(c);
    EXPECT_EQ(s, Clue::Suspect::COLONEL_MUSTARD);

    s = Clue::Suspect::MRS_WHITE;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::MRS_WHITE);
    s = Clue::fromCard<Clue::Suspect>(c);
    EXPECT_EQ(s, Clue::Suspect::MRS_WHITE);

    s = Clue::Suspect::MR_GREEN;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::MR_GREEN);
    s = Clue::fromCard<Clue::Suspect>(c);
    EXPECT_EQ(s, Clue::Suspect::MR_GREEN);

    s = Clue::Suspect::MRS_PEACOCK;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::MRS_PEACOCK);
    s = Clue::fromCard<Clue::Suspect>(c);
    EXPECT_EQ(s, Clue::Suspect::MRS_PEACOCK);

    s = Clue::Suspect::PROFESSOR_PLUM;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::PROFESSOR_PLUM);
    s = Clue::fromCard<Clue::Suspect>(c);
    EXPECT_EQ(s, Clue::Suspect::PROFESSOR_PLUM);

    s = Clue::Suspect::LAST;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::INVALID);
    c = Clue::Card::LAST;
    s = Clue::fromCard<Clue::Suspect>(c);
    EXPECT_EQ(s, Clue::Suspect::INVALID);
}

TEST(ConstantTests, TranslatorWeapon) {
    Clue::Weapon s = Clue::Weapon::NONE;
    Clue::Card c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::NONE);
    s = Clue::fromCard<Clue::Weapon>(c);
    EXPECT_EQ(s, Clue::Weapon::NONE);

    s = Clue::Weapon::CANDLESTICK;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::CANDLESTICK);
    s = Clue::fromCard<Clue::Weapon>(c);
    EXPECT_EQ(s, Clue::Weapon::CANDLESTICK);

    s = Clue::Weapon::DAGGER;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::DAGGER);
    s = Clue::fromCard<Clue::Weapon>(c);
    EXPECT_EQ(s, Clue::Weapon::DAGGER);

    s = Clue::Weapon::LEAD_PIPE;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::LEAD_PIPE);
    s = Clue::fromCard<Clue::Weapon>(c);
    EXPECT_EQ(s, Clue::Weapon::LEAD_PIPE);

    s = Clue::Weapon::REVOLVER;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::REVOLVER);
    s = Clue::fromCard<Clue::Weapon>(c);
    EXPECT_EQ(s, Clue::Weapon::REVOLVER);

    s = Clue::Weapon::ROPE;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::ROPE);
    s = Clue::fromCard<Clue::Weapon>(c);
    EXPECT_EQ(s, Clue::Weapon::ROPE);

    s = Clue::Weapon::WRENCH;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::WRENCH);
    s = Clue::fromCard<Clue::Weapon>(c);
    EXPECT_EQ(s, Clue::Weapon::WRENCH);

    s = Clue::Weapon::LAST;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::INVALID);
    c = Clue::Card::LAST;
    s = Clue::fromCard<Clue::Weapon>(c);
    EXPECT_EQ(s, Clue::Weapon::INVALID);
}

TEST(ConstantTests, TranslatorRoom) {
    Clue::Room s = Clue::Room::NONE;
    Clue::Card c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::NONE);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::NONE);

    s = Clue::Room::KITCHEN;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::KITCHEN);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::KITCHEN);

    s = Clue::Room::BALLROOM;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::BALLROOM);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::BALLROOM);

    s = Clue::Room::CONSERVATORY;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::CONSERVATORY);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::CONSERVATORY);

    s = Clue::Room::BILLIARD_ROOM;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::BILLIARD_ROOM);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::BILLIARD_ROOM);

    s = Clue::Room::LIBRARY;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::LIBRARY);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::LIBRARY);

    s = Clue::Room::STUDY;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::STUDY);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::STUDY);

    s = Clue::Room::HALL;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::HALL);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::HALL);

    s = Clue::Room::LOUNGE;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::LOUNGE);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::LOUNGE);

    s = Clue::Room::DINING_ROOM;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::DINING_ROOM);
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::DINING_ROOM);

    s = Clue::Room::LAST;
    c = Clue::toCard(s);
    EXPECT_EQ(c, Clue::Card::INVALID);
    c = Clue::Card::LAST;
    s = Clue::fromCard<Clue::Room>(c);
    EXPECT_EQ(s, Clue::Room::INVALID);
}