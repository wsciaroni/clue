#pragma once

#include "clue/playerids.h"
#include "clue/card.h"

#include <string>
#include <set>
#include <vector>

namespace Clue
{
class Player
{
private:
    std::string name;
    PlayerId playerId = PlayerId::UNKNOWN;
    std::set<Card> hand;
    std::set<Card> notInHand;

    std::vector<std::set<Card>> showedOneOfTheseVect;

public:
    Player(/* args */);
    ~Player();

    void setName(std::string);
    std::string getName();

    bool isMaster();

    bool hasCard (const Card);
    bool doesntHaveCard (const Card);

    void addCardToHand (Card);
    void removeCardFromHand (Card); // Undo in case oops

    void showedOneOfThese(Suspect, Weapon, Room);

    void cardDefinitelyNotInHand(Card);
};

} // namespace Clue

