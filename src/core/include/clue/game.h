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
    std::vector<std::shared_ptr<Player>> playersStatic;

    std::shared_ptr<QStringListModel> playersQStringListModel = std::make_shared<QStringListModel>();
    
    std::vector<std::shared_ptr<Turn>> turns;
    std::shared_ptr<QStringListModel> turnsStringListModel = std::make_shared<QStringListModel>();

    std::shared_ptr<QStringListModel> suspectsQStringListModel = std::make_shared<QStringListModel>();
    std::shared_ptr<QStringListModel> weaponsQStringListModel = std::make_shared<QStringListModel>();
    std::shared_ptr<QStringListModel> roomsQStringListModel = std::make_shared<QStringListModel>();
    std::shared_ptr<QStringListModel> cardQStringListModel = std::make_shared<QStringListModel>();

    bool isTurnConsistent(std::shared_ptr<Turn>);
    void incrementWhosTurnItIs();

    void regenerateTurnStringList() const;
    void regeneratePlayersTurnList();

    bool needsAnalysis = false;
    void playerHasCard(PlayerId player_in, Card card) const;
    void playerDoesntHaveCard(PlayerId player_in, Card card);

    std::string whoGoesFirst = "NONE";

public:
    Game(/* args */);
    ~Game();

    void submitTurn(std::shared_ptr<Turn>);

    std::shared_ptr<Player> getPlayerByName(const std::string) const;

    void createGame(std::vector<std::string> names, std::set<Card> myHand);
    void setWhoGoesFirst(std::string);
    std::shared_ptr<Player> whosTurnIsIt();

    std::shared_ptr<QStringListModel> getPlayersQStringListModel() const;
    std::shared_ptr<QStringListModel> getTurnsStringListModel() const;

    std::shared_ptr<QStringListModel> getSuspectsQStringListModel() const;
    std::shared_ptr<QStringListModel> getWeaponsQStringListModel() const;
    std::shared_ptr<QStringListModel> getRoomsQStringListModel() const;
    std::shared_ptr<QStringListModel> getCardQStringListModel() const;

    void runAnalysis();

    std::set<std::shared_ptr<Player>> getPlayersBetween(std::shared_ptr<Player>, std::shared_ptr<Player>) const;
    QStringList getWholePlayerListStrings() const;

    std::shared_ptr<std::vector<std::vector<std::string>>> getTableInfo() const;

    u_int8_t getNumberOfPlayers() const;

    class PlayerNotFoundByName : std::exception {
        public:
        const char* what() const noexcept;
    };
};

} // namespace Clue
