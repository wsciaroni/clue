#include "clue/player.h"

#include <algorithm>
namespace Clue
{

void Player::deduceFromPriorTurns()
{
    std::set<Card> cardsWeLearnedWeHave = {};
    std::set<std::array<Card,3>> pastTurnsToRemove = {};
    for(auto it = setOfThreesThisPlayerShowed.begin(); it != setOfThreesThisPlayerShowed.end(); it++) {
        bool haveACard = false;
        Card cardFoundOut = Card::NONE;
        uint8_t dontHaveCardCount = 0;
        for(auto& card : *it) {
            if(hasCard(card)) {
                haveACard = true;
            } else if(doesntHaveCard(card)) {
                dontHaveCardCount++;
            } else {
                cardFoundOut = card;
            }
        }

        if(dontHaveCardCount == 2 && !haveACard) {
            cardsWeLearnedWeHave.insert(cardFoundOut);
        }

        if(haveACard || (dontHaveCardCount == 2 && !haveACard)) {
            pastTurnsToRemove.insert(*it);
        }
    }

    // First remove the turns
    for(auto& arr : pastTurnsToRemove) {
        auto it = std::find(setOfThreesThisPlayerShowed.begin(), setOfThreesThisPlayerShowed.end(), arr);
        if(it != setOfThreesThisPlayerShowed.end()) {
            setOfThreesThisPlayerShowed.erase(it);
        }
    }

    // Then add the cards
    for(auto& card : cardsWeLearnedWeHave) {
        addCardToHand(card);
    }
}

void Player::setName(std::string newName)
{
    this->name = newName;
}

std::string Player::getName() {
    return this->name;
}

void Player::setPlayerId(PlayerId playerId_in) {
    playerId = playerId_in;
}

bool Player::isMaster() {
    return PlayerId::PLAYER_0 == playerId;
}

bool Player::hasCard(const Card card) {
    return (hand->end() != hand->find(card));
}

bool Player::doesntHaveCard(const Card card) {
    return (!hasCard(card) && (notInHand->end() != notInHand->find(card)));
}

void Player::addCardToHand (Card card) {
    if(!hasCard(card)) {
        if(doesntHaveCard(card)) {
            // throw std::__throw_logic_error;
        }
        hand->insert(card);
        deduceFromPriorTurns();
    } else {
        // Card is already in hand
    }
}

void Player::showedOneOfThese(Suspect suspect, Weapon weapon, Room room) {
    std::array<Card, 3> c = {toCard(suspect), toCard(weapon), toCard(room)};
    setOfThreesThisPlayerShowed.insert(c);
    deduceFromPriorTurns();
}

void Player::cardDefinitelyNotInHand(Card card) {
    if (hasCard(card))
    {
        // throw std::__throw_logic_error;
    } else {
        notInHand->insert(card);
        deduceFromPriorTurns();
    }
}

std::shared_ptr<std::set<Card>> Player::getHand() {
    return hand;
}

std::shared_ptr<std::set<Card>> Player::getNotInHand() {
    return notInHand;
}

bool Player::isPlayerSolved() {
    if (!playerSolved && (this->hand->size() >= this->getNumCardsInHand()))
    {
        for(Card i = Card::FIRST; i < Card::LAST; ++i) {
            if(!hasCard(i)) {
                this->cardDefinitelyNotInHand(i);
            }
        }
        this->playerSolved = true;
    }
    return this->playerSolved;
}

void Player::setNumCardsInHand(u_int8_t numCards) {
    numCardsInHand = numCards;
}

u_int8_t Player::getNumCardsInHand() {
    return numCardsInHand;
}

} // namespace Clue
