# pragma once

#include "clue/player.h"
#include "clue/turn.h"
#include "clue/constants.h"

// Include generated protobuf headers
#include "clue.pb.h"

#include <vector>
#include <memory>
#include <set>
#include <string>

namespace Clue
{
class Game
{
private:
    std::vector<std::shared_ptr<Player>> players;
    std::vector<std::shared_ptr<Player>> playersStatic;

    std::vector<std::shared_ptr<Turn>> turns;

    // Previous QStringListModels are now just vectors of strings or messages
    // accessible via getters or constructed on demand for the Proto response.
    // We can keep internal state as C++ objects and convert to Proto on request.

    bool isTurnConsistent(std::shared_ptr<Turn>);
    void incrementWhosTurnItIs();

    // Replaced regenerators with functions that might notify listeners or just update state
    // For now, simple state updates are enough.
    // void regenerateTurnStringList();
    // void regeneratePlayersTurnList();

    bool needsAnalysis = false;
    void playerHasCard(std::shared_ptr<Player> , Card);

    std::string whoGoesFirst = "NONE";

public:
    Game(/* args */);
    ~Game();

    void submitTurn(std::shared_ptr<Turn>);

    std::shared_ptr<Player> getPlayerByName(const std::string);

    void createGame(std::vector<std::string> names, std::set<Card> myHand);
    void setWhoGoesFirst(std::string);
    std::shared_ptr<Player> whosTurnIsIt();

    // Replaced getters for StringListModels with getters for raw data or Proto messages
    const std::vector<std::shared_ptr<Player>>& getPlayers() const;
    const std::vector<std::shared_ptr<Turn>>& getTurns() const;

    // Helpers to get list of strings for UI (via Proto)
    std::vector<std::string> getSuspectsList() const;
    std::vector<std::string> getWeaponsList() const;
    std::vector<std::string> getRoomsList() const;
    std::vector<std::string> getCardsList() const;

    void runAnalysis();

    std::set<std::shared_ptr<Player>> getPlayersBetween(std::shared_ptr<Player>, std::shared_ptr<Player>);
    std::vector<std::string> getWholePlayerListStrings();

    std::shared_ptr<std::vector<std::vector<std::string>>> getTableInfo();

    u_int8_t getNumberOfPlayers();

    // Convert current state to GameStatus proto
    clue::GameStatus toProto() const;

    class PlayerNotFoundByName : std::exception {
        public:
        const char* what() noexcept;
    };
};

} // namespace Clue
