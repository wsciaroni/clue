# pragma once

#include "clue/player.h"
#include "clue/turn.h"

#include <vector>
#include <memory>

namespace Clue
{
class Game
{
private:
    std::vector<std::shared_ptr<Player>> players;
    std::shared_ptr<Player> whosTurnIsIt;
    
    std::vector<std::shared_ptr<Turn>> turns;
    
    bool isTurnConsistent(std::shared_ptr<Turn>);
    void incrementWhosTurnItIs();

public:
    Game(/* args */);
    ~Game();

    void submitTurn(std::shared_ptr<Turn>);

    std::shared_ptr<Player> getPlayerByName(const std::string);

    void createGame(std::vector<std::string>);
};

} // namespace Clue
