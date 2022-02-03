# pragma once

#include "clue/player.h"
#include "clue/turn.h"

#include <vector>
#include <memory>

#include <QStringListModel>

namespace Clue
{
class Game
{
private:
    std::vector<std::shared_ptr<Player>> players;
    std::shared_ptr<QStringListModel> playersQStringListModel = std::make_shared<QStringListModel>();
    
    std::shared_ptr<Player> whosTurnIsIt = nullptr;
    
    std::vector<std::shared_ptr<Turn>> turns;
    std::shared_ptr<QStringListModel> turnsStringListModel = std::make_shared<QStringListModel>();

    std::shared_ptr<QStringListModel> charactersQStringListModel = std::make_shared<QStringListModel>();
    std::shared_ptr<QStringListModel> weaponsQStringListModel = std::make_shared<QStringListModel>();
    std::shared_ptr<QStringListModel> roomsQStringListModel = std::make_shared<QStringListModel>();
    std::shared_ptr<QStringListModel> cardQStringListModel = std::make_shared<QStringListModel>();

    bool isTurnConsistent(std::shared_ptr<Turn>);
    void incrementWhosTurnItIs();

    void regenerateTurnStringList();

public:
    Game(/* args */);
    ~Game();

    void submitTurn(std::shared_ptr<Turn>);

    std::shared_ptr<Player> getPlayerByName(const std::string);

    void createGame(std::vector<std::string>);

    std::shared_ptr<QStringListModel> getPlayersQStringListModel();
    std::shared_ptr<QStringListModel> getTurnsStringListModel();
    std::shared_ptr<QStringListModel> getCharactersQStringListModel();
    std::shared_ptr<QStringListModel> getWeaponsQStringListModel();
    std::shared_ptr<QStringListModel> getRoomsQStringListModel();
    std::shared_ptr<QStringListModel> getCardQStringListModel();
};

} // namespace Clue
