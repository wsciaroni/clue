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
        bool accusationMade = false;

        std::vector<std::shared_ptr<Player>> playersWithoutCards;

        Suspect accusationSuspect = Suspect::NONE;
        Weapon accusationWeapon = Weapon::NONE;
        Room accusationRoom = Room::NONE;

        std::shared_ptr<Player> playerAnswered = nullptr;
        
        Card cardShown = Card::NONE;
        std::shared_ptr<Player> playerShowed = nullptr;

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
            std::shared_ptr<Player> playerShowedIn
            );
        ~Turn();
        
        std::string toString();

        bool getIsMyTurn();
        bool getIAnswered();
        std::shared_ptr<Player> getPlayersTurn();
        std::vector<std::shared_ptr<Player>> getPlayersWithoutCards();
        Suspect getAccusationSuspect();
        Weapon getAccusationWeapon();
        Room getAccusationRoom();
        std::shared_ptr<Player> getPlayerAnswered();
        Card getCardShown();
        std::shared_ptr<Player> getPlayerShowed();
        
    };
} // namespace Clue
