#pragma once

#include "clue/playerids.h"
#include "clue/constants.h"

#include <string>
#include <set>
#include <vector>
#include <memory>

namespace Clue
{
class Player
{
private:
    std::string name;
    PlayerId playerId = PlayerId::UNKNOWN;
    std::shared_ptr<std::set<Card>> hand = std::make_shared<std::set<Card>>();
    std::shared_ptr<std::set<Card>> notInHand = std::make_shared<std::set<Card>>();

    std::vector<std::set<Card>> showedOneOfTheseVect;

    bool playerSolved = false;

    u_int8_t numCardsInHand;

public:
    Player(/* args */);
    ~Player();

    void setName(std::string);
    std::string getName();

    void setPlayerId(PlayerId);

    bool isMaster();

    bool hasCard (const Card);
    bool doesntHaveCard (const Card);

    void addCardToHand (Card);
    void removeCardFromHand (Card); // Undo in case oops

    void showedOneOfThese(Suspect, Weapon, Room);

    void cardDefinitelyNotInHand(Card);

    std::shared_ptr<std::set<Card>> getHand();
    std::shared_ptr<std::set<Card>> getNotInHand();

    bool isPlayerSolved();

    void setNumCardsInHand(u_int8_t numCards);
    u_int8_t getNumCardsInHand();

};

} // namespace Clue

