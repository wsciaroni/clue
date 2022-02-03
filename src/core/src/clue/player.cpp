#include "clue/player.h"
namespace Clue
{
Player::Player(/* args */)
{
}

Player::~Player()
{
}

void Player::setName(std::string newName) {
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
    return (hand.end() != hand.find(card));
}

bool Player::doesntHaveCard(const Card card) {
    return (!hasCard(card) && (notInHand.end() != notInHand.find(card)));
}

void Player::addCardToHand (Card card) {
    if(!hasCard(card)) {
        if(doesntHaveCard(card)) {
            throw std::__throw_logic_error;
        }
        hand.insert(card);
    } else {
        // Card is already in hand
    }
}

void Player::removeCardFromHand(Card card) {
    if(hasCard(card)) {
        hand.erase(hand.find(card));
    }
}

void Player::showedOneOfThese(Suspect suspect, Weapon weapon, Room room) {
    std::set<Card> shown = {toCard(suspect), toCard(weapon), toCard(room)};
    __uint8_t count = 0;
    Card cardInHand = Card::NONE;
    for (auto card : shown)
    {
        if(doesntHaveCard(card)) {
            count++;
        } else {
            cardInHand = card;
        }
    }
    if (2 == count)
    {
        addCardToHand(cardInHand);
    } else {
        // showedOneOfTheseVect.insert(shown);
        // @TODO
    }
}

void Player::cardDefinitelyNotInHand(Card card) {
    if (hasCard(card))
    {
        throw std::__throw_logic_error;
    } else {
        notInHand.insert(card);
    }
}


} // namespace Clue
