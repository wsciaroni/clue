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

        std::set<std::shared_ptr<Player>> playersWithoutCards = {};

        Suspect suggestionSuspect = Suspect::NONE;
        Weapon suggestionWeapon = Weapon::NONE;
        Room suggestionRoom = Room::NONE;

        std::shared_ptr<Player> playerAnswered = nullptr;
        
        Card cardShown = Card::NONE;

    public:
        Turn() = default;
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
        
        std::string toString();

        bool getIsMyTurn() const;
        bool getIAnswered() const;
        std::shared_ptr<Player> getPlayersTurn() const;
        std::set<std::shared_ptr<Player>> getPlayersWithoutCards() const;
        Suspect getAccusationSuspect() const;
        Weapon getAccusationWeapon() const;
        Room getAccusationRoom() const;
        std::shared_ptr<Player> getPlayerAnswered() const;
        Card getCardShown() const;

        void executeTurn() const;
    };
} // namespace Clue
