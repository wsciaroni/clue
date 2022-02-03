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
    std::shared_ptr<Player> whosTurnIsIt = nullptr;
    
    std::vector<std::shared_ptr<Turn>> turns;
    std::shared_ptr<QStringListModel> turnsStringList;

    bool isTurnConsistent(std::shared_ptr<Turn>);
    void incrementWhosTurnItIs();

    void regenerateTurnStringList();

public:
    Game(/* args */);
    ~Game();

    void submitTurn(std::shared_ptr<Turn>);

    std::shared_ptr<Player> getPlayerByName(const std::string);

    void createGame(std::vector<std::string>);
};

} // namespace Clue
