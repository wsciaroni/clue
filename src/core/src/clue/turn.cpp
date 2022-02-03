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
    std::shared_ptr<Player> playerShowedIn
    ) {
    this->playersTurn = playersTurnIn;
    if (this->playersTurn->isMaster())
    {
        this->isMyTurn = true;
    }

    this->accusationMade = accusationMadeIn;
    if(this->accusationMade) {
        this->accusationSuspect = suspectAccusedIn;
        this->accusationWeapon = weaponAccusedIn;
        this->accusationRoom = roomAccusedIn;
        
        // For each player in between playersTurn and playerShowed, 
        // @TODO

        if (this->isMyTurn)
        {
            playerShowedIn->addCardToHand(cardShownIn);
        } else {
            playerShowedIn->showedOneOfThese(suspectAccusedIn, weaponAccusedIn, roomAccusedIn);
        }
        
    }    
    
}

Turn::~Turn() {}

std::string Turn::toString() {
    std::ostringstream oss;
    oss << playersTurn->getName() << " ";
    if (accusationMade)
    {
        oss << "accused " << accusationSuspect.ToString() << " " << accusationWeapon.ToString() << " " << accusationRoom;
        // if 
    }
    
    
    
}

bool Turn::getIsMyTurn() {
    return isMyTurn;
}

std::shared_ptr<Player> Turn::getPlayersTurn() {
    return playersTurn;
}

std::vector<std::shared_ptr<Player>> Turn::getPlayersWithoutCards() {
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

std::shared_ptr<Player> Turn::getPlayerShowed() {
    return playerShowed;
}


} // namespace Clue
