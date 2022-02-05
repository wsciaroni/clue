#include "clue/game.h"
#include "clue/turn.h"

namespace Clue
{

Game::Game(/* args */)
{
    QStringList charactersQStringList;
    for (Suspect i=Suspect::FIRST; i<Suspect::LAST; ++i) {
        charactersQStringList.append(QString::fromStdString(i.ToString()));
    }
    charactersQStringListModel->setStringList(charactersQStringList);

    QStringList weaponsQStringList;
    for (Weapon i=Weapon::FIRST; i<Weapon::LAST; ++i) {
        weaponsQStringList.append(QString::fromStdString(i.ToString()));
    }
    weaponsQStringListModel->setStringList(weaponsQStringList);

    QStringList roomsQStringList;
    for (Room i=Room::FIRST; i<Room::LAST; ++i) {
        roomsQStringList.append(QString::fromStdString(i.ToString()));
    }
    roomsQStringListModel->setStringList(roomsQStringList);

    QStringList cardQStringList;
    cardQStringList.append(charactersQStringList);
    cardQStringList.append(weaponsQStringList);
    cardQStringList.append(roomsQStringList);
    cardQStringList.removeDuplicates();
    cardQStringListModel->setStringList(cardQStringList);
}

Game::~Game()
{
}

bool Game::isTurnConsistent(std::shared_ptr<Turn> turn) {
    // @TODO Check to make sure that this turn doesn't contradict any knowledge that we already have
    return (whosTurnIsIt == turn->getPlayersTurn());
    // return true;
}

void Game::incrementWhosTurnItIs() {
    bool getNextPlayer = false;

    for(auto player : players) {
        if (getNextPlayer)
        {
            whosTurnIsIt = player;
            return;
        }
        
        if(player == whosTurnIsIt) {
            if (players.back() == player)
            {
                whosTurnIsIt = players.front();
                return;
            } else {
                getNextPlayer = true;
            }
        }
    }

    throw std::logic_error("Unable to determine the next player");
}

void Game::regenerateTurnStringList() {
    QStringList strings;
    strings.clear();
    for (auto turn : turns)
    {
        strings.append(QString::fromStdString(turn->toString()));
    }
    turnsStringListModel->setStringList(strings);
}

void Game::submitTurn(std::shared_ptr<Turn> turn) {
    if (isTurnConsistent(turn))
    {
        turns.push_back(turn);
        incrementWhosTurnItIs();
        regenerateTurnStringList();
        return;
    }
    throw std::logic_error("Turn is not consistent");
}

std::shared_ptr<Player> Game::getPlayerByName(const std::string name) {
    for (auto player : players) {
        if (name == player->getName())
        {
            return player;
        }
    }
    // throw std::range_error("Player not found");
    return nullptr;
}

void Game::createGame(std::vector<std::string> names) {
    auto playerNumber = static_cast<u_int8_t>(PlayerId::PLAYER_0);
    // players.resize(names.size());
    QStringList nameList;
    bool firstPlayer = true;
    for (auto playerName : names) {
        auto player = std::make_shared<Player>();
        player->setName(playerName);
        player->setPlayerId(static_cast<PlayerId>(playerNumber));
        players.push_back(player);
        nameList.append(QString::fromStdString(playerName));
        playerNumber++;
        if((firstPlayer && "NONE" == whoGoesFirst) || playerName == whoGoesFirst) {
            whosTurnIsIt = player;
        }
        firstPlayer = false;
    }
    playersQStringListModel->setStringList(nameList);
}

void Game::setWhoGoesFirst(std::string firstPlayer) {
    whoGoesFirst = firstPlayer;
}

std::shared_ptr<QStringListModel> Game::getPlayersQStringListModel() {
    return playersQStringListModel;
}

std::shared_ptr<QStringListModel> Game::getTurnsStringListModel() {
    return turnsStringListModel;
}

std::shared_ptr<QStringListModel> Game::getCharactersQStringListModel() {
    return charactersQStringListModel;
}

std::shared_ptr<QStringListModel> Game::getWeaponsQStringListModel() {
    return weaponsQStringListModel;
}

std::shared_ptr<QStringListModel> Game::getRoomsQStringListModel() {
    return roomsQStringListModel;
}
std::shared_ptr<QStringListModel> Game::getCardQStringListModel() {
    return cardQStringListModel;
}

void Game::runAnalysis() {
    while (needsAnalysis)
    {
        needsAnalysis = false;
        for (auto turn : turns)
        {
            auto playerAnswered = turn->getPlayerAnswered();
            if (
                playerAnswered->hasCard(toCard(turn->getAccusationRoom())) || playerAnswered->hasCard(toCard(turn->getAccusationSuspect())) || playerAnswered->hasCard(toCard(turn->getAccusationWeapon())))
            {
                // We already know that they have one of the cards, hence we can known nothing else
            }
            else if (turn->getPlayerAnswered()->doesntHaveCard(toCard(turn->getAccusationSuspect())) && turn->getPlayerAnswered()->doesntHaveCard(toCard(turn->getAccusationWeapon())))
            {
                playerHasCard(playerAnswered,toCard(turn->getAccusationRoom()));
            }
            else if (turn->getPlayerAnswered()->doesntHaveCard(toCard(turn->getAccusationRoom())) && turn->getPlayerAnswered()->doesntHaveCard(toCard(turn->getAccusationWeapon())))
            {
                playerHasCard(playerAnswered,toCard(turn->getAccusationSuspect()));
            }
            else if (turn->getPlayerAnswered()->doesntHaveCard(toCard(turn->getAccusationRoom())) && turn->getPlayerAnswered()->doesntHaveCard(toCard(turn->getAccusationSuspect())))
            {
                playerHasCard(playerAnswered,toCard(turn->getAccusationWeapon()));
            }

            // For players between player accusing and player answering.
            // If No one answered && the card is either the answer or in that players hand. We can't be sure.
            for (auto player : turn->getPlayersWithoutCards())
            {
                // @TODO Move this into the part where the turn is created.
                player->cardDefinitelyNotInHand(toCard(turn->getAccusationRoom()));
                player->cardDefinitelyNotInHand(toCard(turn->getAccusationSuspect()));
                player->cardDefinitelyNotInHand(toCard(turn->getAccusationWeapon()));
            }
        }

        for (auto player : players) {
            // If they have three cards, they definitely don't have the rest of the cards
            auto hand = player->getHand();
            auto notInHand = player->getNotInHand();
            if(player->isPlayerSolved()) {
                // This player is solved.
            } else if (notInHand->size() >= (NUMBER_OF_CARDS-NUMBER_OF_CARDS_IN_PLAYERS_HAND)) {
                // We know the player doesn't have the rest of the cards, so, deduce that they do have the rest of the cards.
                for (Card i=Card::FIRST; i<Card::LAST; ++i) {
                    if (!player->doesntHaveCard(i))
                    {
                        playerHasCard(player, i);
                    }
                }
            }
        }
    }
}

void Game::playerHasCard(std::shared_ptr<Player> player_in, Card card) {
    for(auto player : players) {
        if (player_in == player)
        {
            player->addCardToHand(card);
        } else {
            player->cardDefinitelyNotInHand(card);
        }
    }
    needsAnalysis = true;
}

std::set<std::shared_ptr<Player>> Game::getPlayersBetween(std::shared_ptr<Player> current, std::shared_ptr<Player> end) {
    std::set<std::shared_ptr<Player>> playersBetween;
    // if(current == end) {
    //     return playersBetween;
    // } else {
        for(auto it = std::find(players.begin(), players.end(), current); it != std::find(players.begin(), players.end(), end); ++it) {
            if (std::end(players) == it)
            {
                it = std::begin(players);
                it++;
            }
            if(current != *it && end != *it) {
                playersBetween.insert(*it);
            }
        }
    // }
    return playersBetween;
}
} // namespace Clue
