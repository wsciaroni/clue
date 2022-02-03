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
                whosTurnIsIt = players.back();
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
    for (auto playerName : names) {
        auto player = std::make_shared<Player>();
        player->setName(playerName);
        player->setPlayerId(static_cast<PlayerId>(playerNumber));
        players.push_back(player);
        nameList.append(QString::fromStdString(playerName));
        playerNumber++;
    }
    playersQStringListModel->setStringList(nameList);
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

} // namespace Clue
