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
    std::shared_ptr<QStringListModel> playerShownQStringListModel = std::make_shared<QStringListModel>();
    std::shared_ptr<QStringListModel> whoAnsweredQStringListModel = std::make_shared<QStringListModel>();
    
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

    bool needsAnalysis = false;
    void playerHasCard(std::shared_ptr<Player> , Card);

    std::string whoGoesFirst = "NONE";

public:
    Game(/* args */);
    ~Game();

    void submitTurn(std::shared_ptr<Turn>);

    std::shared_ptr<Player> getPlayerByName(const std::string);

    void createGame(std::vector<std::string>);
    void setWhoGoesFirst(std::string);

    std::shared_ptr<QStringListModel> getPlayersQStringListModel();
    std::shared_ptr<QStringListModel> getTurnsStringListModel();
    std::shared_ptr<QStringListModel> getCharactersQStringListModel();
    std::shared_ptr<QStringListModel> getWeaponsQStringListModel();
    std::shared_ptr<QStringListModel> getRoomsQStringListModel();
    std::shared_ptr<QStringListModel> getCardQStringListModel();

    void runAnalysis();

    std::set<std::shared_ptr<Player>> getPlayersBetween(std::shared_ptr<Player>, std::shared_ptr<Player>);

    std::shared_ptr<std::vector<std::vector<std::string>>> getTableInfo();

    u_int8_t getNumberOfPlayers();
};

} // namespace Clue
