#include "clue/turn.h"

#include <iomanip>

namespace Clue
{

Turn::Turn() {

}

Turn::Turn(
    std::shared_ptr<Player> playersTurnIn,
    bool accusationMadeIn,
    Suspect suspectAccusedIn,
    Weapon weaponAccusedIn,
    Room roomAccusedIn,
    std::shared_ptr<Player> playerAnsweredIn,
    Card cardShownIn,
    std::set<std::shared_ptr<Player>> playersWithoutCardsIn
    ) {
    this->playersTurn = playersTurnIn;
    this->playerAnswered = playerAnsweredIn;
    this->cardShown = cardShownIn;

    if (this->playersTurn->isMaster())
    {
        this->isMyTurn = true;
    } else if(this->playerAnswered->isMaster()) {
        this->iAnswered = true;
    }

    this->accusationMade = accusationMadeIn;
    if(this->accusationMade) {
        this->accusationSuspect = suspectAccusedIn;
        this->accusationWeapon = weaponAccusedIn;
        this->accusationRoom = roomAccusedIn;

        if (this->isMyTurn)
        {
            playerAnswered->addCardToHand(cardShownIn);
        } else {
            playerAnswered->showedOneOfThese(suspectAccusedIn, weaponAccusedIn, roomAccusedIn);
        }
        this->playersWithoutCards = playersWithoutCardsIn;
    }    
    
}

Turn::~Turn() {}

std::string Turn::toString() {
    std::ostringstream oss;
    oss << this->playersTurn->getName() << " ";
    if (accusationMade)
    {
        oss << "accused " << this->accusationSuspect.ToString() << " " << this->accusationWeapon.ToString() << " " << this->accusationRoom.ToString();
        if (this->playersTurn == this->playerAnswered)
        {
            oss << ", and no-one answered.";
        } else {
            oss << ", and " << this->playerAnswered->getName() << " answered.";
            if(this->isMyTurn) {
                oss << " They showed me " << this->cardShown.ToString();
            } else if(this->iAnswered) {
                oss << " I showed them " << this->cardShown.ToString();
            }
        }
        if(0 != playersWithoutCards.size()) {
            oss << " We learned that the following players don't have these three cards:";
            for(auto player : this->playersWithoutCards) {
                oss << " " << player->getName();
            }
            oss << ".";
        }
    } else {
        oss << "did not make an accusation.";
    }
    return oss.str();
}

bool Turn::getIsMyTurn() {
    return isMyTurn;
}

bool Turn::getIAnswered() {
    return iAnswered;
}

std::shared_ptr<Player> Turn::getPlayersTurn() {
    return playersTurn;
}

std::set<std::shared_ptr<Player>> Turn::getPlayersWithoutCards() {
    return playersWithoutCards;
}

Suspect Turn::getAccusationSuspect() {
    return accusationSuspect;
}

Weapon Turn::getAccusationWeapon() {
    return accusationWeapon;
}

Room Turn::getAccusationRoom() {
    return accusationRoom;
}

std::shared_ptr<Player> Turn::getPlayerAnswered() {
    return playerAnswered;
}

Card Turn::getCardShown() {
    return cardShown;
}

} // namespace Clue
