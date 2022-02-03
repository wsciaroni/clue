#include "clue/game.h"
#include "clue/turn.h"

namespace Clue
{

Game::Game(/* args */)
{
    QStringList charactersQStringList;
    charactersQStringList.append(QString::fromStdString(toString(Suspect::NONE)));
    charactersQStringList.append(QString::fromStdString(toString(Suspect::MISS_SCARLET)));
    charactersQStringList.append(QString::fromStdString(toString(Suspect::COLONEL_MUSTARD)));
    charactersQStringList.append(QString::fromStdString(toString(Suspect::MRS_WHITE)));
    charactersQStringList.append(QString::fromStdString(toString(Suspect::MR_GREEN)));
    charactersQStringList.append(QString::fromStdString(toString(Suspect::MRS_PEACOCK)));
    charactersQStringList.append(QString::fromStdString(toString(Suspect::PROFESSOR_PLUM)));
    charactersQStringListModel->setStringList(charactersQStringList);

    QStringList weaponsQStringList;
    weaponsQStringList.append(QString::fromStdString(toString(Weapon::NONE)));
    weaponsQStringList.append(QString::fromStdString(toString(Weapon::CANDLESTICK)));
    weaponsQStringList.append(QString::fromStdString(toString(Weapon::DAGGER)));
    weaponsQStringList.append(QString::fromStdString(toString(Weapon::LEAD_PIPE)));
    weaponsQStringList.append(QString::fromStdString(toString(Weapon::REVOLVER)));
    weaponsQStringList.append(QString::fromStdString(toString(Weapon::ROPE)));
    weaponsQStringList.append(QString::fromStdString(toString(Weapon::WRENCH)));
    weaponsQStringListModel->setStringList(weaponsQStringList);

    QStringList roomsQStringList;
    roomsQStringList.append(QString::fromStdString(toString(Room::NONE)));
    roomsQStringList.append(QString::fromStdString(toString(Room::KITCHEN)));
    roomsQStringList.append(QString::fromStdString(toString(Room::BALLROOM)));
    roomsQStringList.append(QString::fromStdString(toString(Room::CONSERVATORY)));
    roomsQStringList.append(QString::fromStdString(toString(Room::BILLIARD_ROOM)));
    roomsQStringList.append(QString::fromStdString(toString(Room::LIBRARY)));
    roomsQStringList.append(QString::fromStdString(toString(Room::STUDY)));
    roomsQStringList.append(QString::fromStdString(toString(Room::HALL)));
    roomsQStringList.append(QString::fromStdString(toString(Room::LOUNGE)));
    roomsQStringList.append(QString::fromStdString(toString(Room::DINING_ROOM)));
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
