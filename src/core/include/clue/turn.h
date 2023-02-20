#pragma once

#include "clue/player.h"
#include "clue/constants.h"
#include <memory>
#include <vector>

namespace Clue
{
    /**
     * @brief Holds the information of a single turn
     *
     * Used to pass turn information from the UI builder to the "Game"
     * Within the game, this class will update the player's hands based on information learned.
     */
    class Turn
    {
    private:
        /// @brief True if I was the player who's turn it was
        bool isMyTurn = false;

        /// @brief  True if I was the player who answered (Or it was my turn and I answered...)
        bool iAnswered = false;

        /// @brief The player who's turn it is
        std::shared_ptr<Player> playersTurn = nullptr;

        /// @brief True if a suggestion was made
        bool suggestionMade = false;

        /// @brief Set of player's who said "I don't have one of those three cards"
        std::set<std::shared_ptr<Player>> playersWithoutCards = {};

        /// @brief The Suspect that was suggested
        Suspect suggestionSuspect = Suspect::NONE;
        /// @brief The Weapon that was suggested
        Weapon suggestionWeapon = Weapon::NONE;
        /// @brief The Room that was suggested
        Room suggestionRoom = Room::NONE;

        /// @brief The player who answered. Equal to playersTurn if no one answered
        std::shared_ptr<Player> playerAnswered = nullptr;

        /// @brief The Card that was shown
        Card cardShown = Card::NONE;

    public:
        Turn() = default;

        /// @brief Constructor for My turn in which I made an accusation && I saw a card
        /// @param playersTurnIn The player who's turn it is
        /// @param accusationMadeIn True if a suggestion was made
        /// @param suspectAccusedIn The Suspect that was suggested
        /// @param weaponAccusedIn The Weapon that was suggested
        /// @param roomAccusedIn The Room that was suggested
        /// @param playerAnsweredIn The player who answered. Equal to playersTurn if no one answered
        /// @param cardShownIn The Card that was shown
        /// @param playersWithoutCards Set of player's who said "I don't have one of those three cards"
        explicit Turn(
            std::shared_ptr<Player> playersTurnIn,
            bool accusationMadeIn,
            Suspect suspectAccusedIn,
            Weapon weaponAccusedIn,
            Room roomAccusedIn,
            std::shared_ptr<Player> playerAnsweredIn,
            Card cardShownIn,
            const std::set<std::shared_ptr<Player>>& playersWithoutCards
            );


        /// @brief Constructor for a turn where no-one made an accusation
        /// Used for testing to quickly write turns... Probably not used in the game
        /// @param playersTurnIn The player who's turn it is
        explicit Turn(
            std::shared_ptr<Player> playersTurnIn
        );

        /// @brief Get what happened in this turn, in a string
        /// @return A human readable string of the events of this turn
        std::string toString() const;

        /// @brief Check if it was my turn
        /// @return True if I was the player who's turn it was
        bool getIsMyTurn() const;

        /// @brief Check if I answered
        /// @return True if I was the player who answered (Or it was my turn and I answered...)
        bool getIAnswered() const;

        /// @brief Check to see who's turn it was
        /// @return playersTurn
        std::shared_ptr<Player> getPlayersTurn() const;

        /// @brief Get the list of player's who didn't have any of the suggested cards
        /// @return playersWithoutCards
        std::set<std::shared_ptr<Player>> getPlayersWithoutCards() const;

        /// @brief The Suspect that was suggested
        Suspect getAccusationSuspect() const;
        /// @brief The Weapon that was suggested
        Weapon getAccusationWeapon() const;
        /// @brief The Room that was suggested
        Room getAccusationRoom() const;

        /// @brief The player who answered. Equal to playersTurn if no one answered
        std::shared_ptr<Player> getPlayerAnswered() const;

        /// @brief The Card that was shown
        /// Either I showed it to someone (If I answered)
        /// or They showed it to me (If it was my turn)
        /// @return The Card that was shown
        Card getCardShown() const;

        /// @brief Update the players based on the information learned in this turn
        void executeTurn() const;

        /// @brief Check if I was shown a card
        /// @return True if I saw someone's card
        bool cardWasShownToMe() const;

        /// @brief Check if I showed someone a card
        /// @return True if I showed someone a card
        bool iShowedACard() const;
    };
} // namespace Clue
