#pragma once

#include "clue/player.h"
#include "clue/constants.h"
#include <memory>
#include <vector>

namespace Clue
{
    class Turn
    {
    private:
        bool isMyTurn = false;
        bool iAnswered = false;

        std::shared_ptr<Player> playersTurn = nullptr;
        bool suggestionMade = false;

        std::set<std::shared_ptr<Player>> playersWithoutCards;

        Suspect suggestionSuspect = Suspect::NONE;
        Weapon suggestionWeapon = Weapon::NONE;
        Room suggestionRoom = Room::NONE;

        std::shared_ptr<Player> playerAnswered = nullptr;
        
        Card cardShown = Card::NONE;

    public:
        Turn();
        Turn(
            std::shared_ptr<Player> playersTurnIn,
            bool accusationMadeIn,
            Suspect suspectAccusedIn,
            Weapon weaponAccusedIn,
            Room roomAccusedIn,
            std::shared_ptr<Player> playerAnsweredIn,
            Card cardShownIn,
            std::set<std::shared_ptr<Player>> playersWithoutCards
            );
        ~Turn();
        
        std::string toString();

        bool getIsMyTurn();
        bool getIAnswered();
        std::shared_ptr<Player> getPlayersTurn();
        std::set<std::shared_ptr<Player>> getPlayersWithoutCards();
        Suspect getAccusationSuspect();
        Weapon getAccusationWeapon();
        Room getAccusationRoom();
        std::shared_ptr<Player> getPlayerAnswered();
        Card getCardShown();
    };
} // namespace Clue
