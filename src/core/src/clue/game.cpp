#include "clue/game.h"
#include "clue/turn.h"

#include <iostream>
#include <glog/logging.h>
#include <algorithm>

namespace Clue
{

Game::Game(/* args */)
{
    QStringList charactersQStringList;
    for (Suspect i=Suspect::FIRST; i<Suspect::LAST; ++i) {
        charactersQStringList.append(QString::fromStdString(i.ToString()));
    }
    suspectsQStringListModel->setStringList(charactersQStringList);

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
    if (whosTurnIsIt() != turn->getPlayersTurn()) {
        return false;
    }
    // Check to make sure someone didn't show us a card that we already know about
    // Check to make sure we didn't show a card that we don't have
    if(turn->getPlayerAnswered()->doesntHaveCard(turn->getCardShown())) {
        // the player answered doesn't have that card...
        return false;
    }
    for (auto player : playersStatic)
    {
        if ((player != turn->getPlayerAnswered()) && (player->hasCard(turn->getCardShown())))
        {
            // That person can't have that card. We've already ruled it out
            return false;
        }
    }
    return true;
}

void Game::incrementWhosTurnItIs() {
    std::rotate(players.begin(), players.begin() + 1, players.end());
    regeneratePlayersTurnList();
}

void Game::regenerateTurnStringList() {
    QStringList strings;
    strings.clear();
    uint64_t turnNumber = 1;
    for (auto turn : turns)
    {
        strings.append(QString::number(turnNumber) + "\t| " + QString::fromStdString(turn->toString()));
        turnNumber++;
    }
    turnsStringListModel->setStringList(strings);
}

void Game::regeneratePlayersTurnList() {
    QStringList strings;
    strings.clear();
    strings.append(QString::fromStdString(players.front()->getName()));
    playersQStringListModel->setStringList(strings);
}

void Game::submitTurn(std::shared_ptr<Turn> turn) {
    LOG(INFO) << "Turn submitted to game: " << turn->toString();
    try {
        if (isTurnConsistent(turn))
        {
            turns.push_back(turn);
            turn->executeTurn();
            incrementWhosTurnItIs();
            regenerateTurnStringList();
            runAnalysis();
            return;
        }
    } catch(const std::exception& e)
    {
        LOG(WARNING) << e.what();
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
    throw Game::PlayerNotFoundByName();
}

void Game::createGame(std::vector<std::string> names, std::set<Card> myHand) {
    auto playerNumber = static_cast<u_int8_t>(PlayerId::PLAYER_0);
    // players.resize(names.size());
    QStringList nameList;
    for (auto playerName : names) {
        auto player = std::make_shared<Player>();
        player->setName(playerName);
        player->setPlayerId(static_cast<PlayerId>(playerNumber));

        /*
         * If there are 3 players : 6, 6, 6
         * If there are 4 players : 5, 5, 4, 4
         * If there are 5 players : 4, 4, 4, 3, 3
         * If there are 6 players : 3, 3, 3, 3, 3
         */
        u_int8_t numCards = std::floor(float(NUMBER_OF_CARDS-3)/float(names.size()));
        u_int8_t numCardsInHand = (playerNumber <= (names.size()-2)) ? numCards+1 : numCards;
        player->setNumCardsInHand(numCardsInHand);

        players.push_back(player);
        nameList.append(QString::fromStdString(playerName));
        playerNumber++;
    }
    playersStatic = players;

    playersQStringListModel->setStringList(nameList);
    if ("NONE" != whoGoesFirst)
    {
        for(const auto& playerName : names) {
            if (players.front()->getName() == whoGoesFirst)
            {
                break;
            } else {
                incrementWhosTurnItIs();
            }
        }
    }

    for(auto card : myHand) {
        playerHasCard(playersStatic.front(), card);
    }
    runAnalysis();
    getTableInfo();
}

void Game::setWhoGoesFirst(std::string firstPlayer) {
    whoGoesFirst = firstPlayer;
}

std::shared_ptr<Player> Game::whosTurnIsIt() {
    return players.front();
}

std::shared_ptr<QStringListModel> Game::getPlayersQStringListModel() {
    return playersQStringListModel;
}

std::shared_ptr<QStringListModel> Game::getTurnsStringListModel() {
    return turnsStringListModel;
}

std::shared_ptr<QStringListModel> Game::getSuspectsQStringListModel() {
    return suspectsQStringListModel;
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
    needsAnalysis = true;
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
            } else if (notInHand->size() >= (NUMBER_OF_CARDS - player->getNumCardsInHand())) {
                // We know the player doesn't have the rest of the cards, so, deduce that they do have the rest of the cards.
                for (Card i=Card::FIRST; i<Card::LAST; ++i) {
                    if (!player->doesntHaveCard(i))
                    {
                        playerHasCard(player, i);
                    }
                }
            } else if (hand->size() >= player->getNumCardsInHand()) {
                // We know all of the players cards. So, they don't have the rest of the cards
                for (Card i=Card::FIRST; i<Card::LAST; i++) {
                    if(!player->hasCard(i)) {
                        player->cardDefinitelyNotInHand(i);
                    }
                }
            }

            // Make sure the card isn't in any of the other players hands
            for(auto card : *hand) {
                playerHasCard(player, card);
            }
        }
    }
}

void Game::playerHasCard(std::shared_ptr<Player> player_in, Card card) {
    if(!player_in->hasCard(card)) {
        needsAnalysis = true;
    }
    for(auto player : players) {
        if (player_in == player)
        {
            player->addCardToHand(card);
        } else {
            player->cardDefinitelyNotInHand(card);
        }
    }
}

std::set<std::shared_ptr<Player>> Game::getPlayersBetween(std::shared_ptr<Player> current, std::shared_ptr<Player> end) {
    std::set<std::shared_ptr<Player>> playersBetween;

    // If the person who accused and the person who answered are the same, that means no one else had the card.
    if(current == end) {
        for(auto player : players) {
            if(player != current) {
                playersBetween.insert(player);
            }
        }
        return playersBetween;
    }

    bool haveEncounteredStart = false;
    bool haveEncounteredEnd = false;
    bool encounteredStartFirst = false;
    for(auto player : players) {
        if(player == current) {
            haveEncounteredStart = true;
            if(!haveEncounteredEnd) {
                playersBetween.clear();
                encounteredStartFirst = true;
            }
        } else if (player == end) {
            haveEncounteredEnd = true;
            if(!haveEncounteredStart) {
                encounteredStartFirst = false;
            }
        } else if (!haveEncounteredStart && !haveEncounteredEnd) {
            playersBetween.insert(player);
        } else if (haveEncounteredEnd && !haveEncounteredStart) {
            // don't add this person to the list
        } else if (haveEncounteredStart && !haveEncounteredEnd) {
            playersBetween.insert(player);
        } else if (haveEncounteredStart && haveEncounteredEnd) {
            if(encounteredStartFirst) {
                // Don't add this person to the list. We've already seen both the start and the end
            } else {
                // We saw the end first, so we want the people before and after
                playersBetween.insert(player);
            }
        }
    }
    return playersBetween;
}

QStringList Game::getWholePlayerListStrings() {
    QStringList list;
    for(auto player : players) {
        list.append(QString::fromStdString(player->getName()));
    }
    return list;
}

std::shared_ptr<std::vector<std::vector<std::string>>> Game::getTableInfo() {
    auto tableInfo = std::make_shared<std::vector<std::vector<std::string>>>();
    // Number of cards
    for(int i = 0; i <= NUMBER_OF_CARDS; i++) {
        std::vector<std::string> row;
        for(int j = 0; j <= getNumberOfPlayers(); j++) {
            std::string column = "";
            row.push_back(column);
        }
        tableInfo->push_back(row);
    }
    // Add headers
    {
        uint64_t row = 0;
        for (Card card=Card::FIRST; card<Card::LAST; ++card) {
            if(0 < row) {
                (*tableInfo)[row][0] = card.ToString();
            }
            row++;
        }

        uint64_t column = 1;
        for (auto player : playersStatic)
        {
            (*tableInfo)[0][column] = player->getName();
            column++;
        }
    }

    // For each card, for each  Determine the state
    uint64_t row = 0;
    for (Card card=Card::FIRST; card<Card::LAST; ++card)
    {
        if( 0 < row ) {
            uint64_t column = 1;
            for (auto player : playersStatic)
            {
                if (player->doesntHaveCard(card)) {
                    // Doesn't have card
                    (*tableInfo)[row][column] = "O";
                } else if (player->hasCard(card)) {
                    // Player has Card
                    (*tableInfo)[row][column] = "X";
                } else {
                    // We don't know
                    (*tableInfo)[row][column] = "?";
                }
                column++;
            }
        }
        row++;
    }
    return tableInfo;
}

u_int8_t Game::getNumberOfPlayers() {
    return players.size();
}

const char*  Game::PlayerNotFoundByName::what() noexcept {
    return "Player not found by name";
}

} // namespace Clue
