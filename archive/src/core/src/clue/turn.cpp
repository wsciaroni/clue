#include "clue/turn.h"

#include <iomanip>

namespace Clue
{
Turn::Turn(
    std::shared_ptr<Player> playersTurnIn,
    bool suggestionMadeIn,
    Suspect suspectSuggestedIn,
    Weapon weaponSuggestedIn,
    Room roomSuggestedIn,
    std::shared_ptr<Player> playerAnsweredIn,
    Card cardShownIn,
    const std::set<std::shared_ptr<Player>>& playersWithoutCardsIn
    ) : isMyTurn(playersTurnIn->isMaster()),
        iAnswered(!playersTurnIn->isMaster() && playerAnsweredIn->isMaster()),
        playersTurn(playersTurnIn),
        suggestionMade(suggestionMadeIn),
        playersWithoutCards(playersWithoutCardsIn),
        suggestionSuspect(suspectSuggestedIn),
        suggestionWeapon(weaponSuggestedIn),
        suggestionRoom(roomSuggestedIn),
        playerAnswered(playerAnsweredIn),
        cardShown(cardShownIn)
    {}

    Turn::Turn(
        std::shared_ptr<Player> playersTurnIn
    ) : isMyTurn(playersTurnIn->isMaster()),
        iAnswered(false),
        playersTurn(playersTurnIn),
        playerAnswered(playersTurnIn)
    {}

    std::string Turn::toString() const
    {
        std::ostringstream oss;
        oss << this->playersTurn->getName() << " ";
        if (suggestionMade)
        {
            oss << "accused " << this->suggestionSuspect.ToString() << " " << this->suggestionWeapon.ToString() << " " << this->suggestionRoom.ToString();
            if (this->playersTurn == this->playerAnswered)
            {
                oss << ", and no-one answered.";
            }
            else
            {
                oss << ", and " << this->playerAnswered->getName() << " answered.";
                if (this->isMyTurn)
                {
                    oss << " They showed me " << this->cardShown.ToString();
                }
                else if (this->iAnswered)
                {
                    oss << " I showed them " << this->cardShown.ToString();
                }
            }
            if (!playersWithoutCards.empty())
            {
                oss << " We learned that the following players don't have these three cards:";
                for (auto player : this->playersWithoutCards)
                {
                    oss << " " << player->getName();
                }
                oss << ".";
            }
        }
        else
        {
            oss << "did not make an accusation.";
        }
        return oss.str();
    }

bool Turn::getIsMyTurn() const {
    return isMyTurn;
}

bool Turn::getIAnswered() const {
    return iAnswered;
}

std::shared_ptr<Player> Turn::getPlayersTurn() const {
    return playersTurn;
}

std::set<std::shared_ptr<Player>> Turn::getPlayersWithoutCards() const {
    return playersWithoutCards;
}

Suspect Turn::getAccusationSuspect() const {
    return suggestionSuspect;
}

Weapon Turn::getAccusationWeapon() const {
    return suggestionWeapon;
}

Room Turn::getAccusationRoom() const {
    return suggestionRoom;
}

std::shared_ptr<Player> Turn::getPlayerAnswered() const {
    return playerAnswered;
}

Card Turn::getCardShown() const {
    return cardShown;
}

void Turn::executeTurn() const
{
        if(this->suggestionMade) {
        if (this->isMyTurn)
        {
            playerAnswered->addCardToHand(cardShown);
        } else {
            playerAnswered->showedOneOfThese(suggestionSuspect, suggestionWeapon, suggestionRoom);
        }

        for(auto player : playersWithoutCards) {
            player->cardDefinitelyNotInHand(toCard(suggestionSuspect));
            player->cardDefinitelyNotInHand(toCard(suggestionWeapon));
            player->cardDefinitelyNotInHand(toCard(suggestionRoom));
        }
    }
}

bool Turn::aCardWasShown() const
{
    return (playerAnswered != playersTurn) && suggestionMade;
}

bool Turn::cardWasShownToMe() const
{
    return aCardWasShown() && playersTurn->isMaster();
}

bool Turn::iShowedACard() const
{
    return aCardWasShown() && playerAnswered->isMaster();
}

} // namespace Clue
