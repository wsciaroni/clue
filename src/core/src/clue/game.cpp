#include "clue/game.h"
#include <iostream>
#include <algorithm>

namespace Clue
{

Game::Game(/* args */)
{
}

Game::~Game()
{
}

void Game::createGame(std::vector<std::string> names, std::set<Card> myHand)
{
    players.clear();
    playersStatic.clear();
    for (const auto& name : names)
    {
        std::shared_ptr<Player> newPlayer = std::make_shared<Player>();
        newPlayer->setName(name);
        if (names.size() > 0 && name == names.at(0)) {
            newPlayer->setPlayerId(PlayerId::PLAYER_1); // I am always first
            for (auto card : myHand)
            {
                newPlayer->addCardToHand(card);
            }
        }
        players.push_back(newPlayer);
        playersStatic.push_back(newPlayer);
    }
}

void Game::setWhoGoesFirst(std::string name)
{
    whoGoesFirst = name;
    while(players.front()->getName() != name)
    {
        players.push_back(players.front());
        players.erase(players.begin());
    }
}

std::shared_ptr<Player> Game::whosTurnIsIt() {
    if (players.empty()) {
        return nullptr;
    }
    return players.front();
}

void Game::submitTurn(std::shared_ptr<Turn> turn) {
    if (isTurnConsistent(turn)) {
        turn->executeTurn();
        incrementWhosTurnItIs();
        turns.push_back(turn);
        runAnalysis();
    }
}

bool Game::isTurnConsistent(std::shared_ptr<Turn> turn) {
    // Basic consistency check
    if (turn->getPlayersTurn() != players.front()) {
        return false;
    }
    return true;
}

void Game::incrementWhosTurnItIs() {
    if (!players.empty()) {
        players.push_back(players.front());
        players.erase(players.begin());
    }
}

std::shared_ptr<Player> Game::getPlayerByName(const std::string name) {
    for (auto player : playersStatic) {
        if (player->getName() == name) {
            return player;
        }
    }
    throw PlayerNotFoundByName();
}

const std::vector<std::shared_ptr<Player>>& Game::getPlayers() const {
    return playersStatic;
}

const std::vector<std::shared_ptr<Turn>>& Game::getTurns() const {
    return turns;
}

std::vector<std::string> Game::getSuspectsList() const {
    std::vector<std::string> list;
    for (auto i = Suspect::FIRST; i != Suspect::LAST; ++i) {
        list.push_back(i.ToString());
    }
    return list;
}

std::vector<std::string> Game::getWeaponsList() const {
    std::vector<std::string> list;
    for (auto i = Weapon::FIRST; i != Weapon::LAST; ++i) {
        list.push_back(i.ToString());
    }
    return list;
}

std::vector<std::string> Game::getRoomsList() const {
    std::vector<std::string> list;
    for (auto i = Room::FIRST; i != Room::LAST; ++i) {
        list.push_back(i.ToString());
    }
    return list;
}

std::vector<std::string> Game::getCardsList() const {
    std::vector<std::string> list;
    for (auto i = Card::FIRST; i != Card::LAST; ++i) {
        list.push_back(i.ToString());
    }
    return list;
}

std::vector<std::string> Game::getWholePlayerListStrings() {
    std::vector<std::string> list;
    for (auto player : playersStatic) {
        list.push_back(player->getName());
    }
    return list;
}

void Game::playerHasCard(std::shared_ptr<Player> player, Card card) {
    // Logic for handling player having a card
    player->addCardToHand(card);
    for(auto otherPlayer : playersStatic) {
        if (otherPlayer != player) {
            otherPlayer->cardDefinitelyNotInHand(card);
        }
    }
}

void Game::runAnalysis() {
    // Re-implement analysis logic if needed or just keep existing logic
    // For now, trigger deduction on players
    // This is a simplified version of what might have been there
    /*
    for (auto player : playersStatic) {
        // player->deduceFromPriorTurns(); // Assuming this method exists or logic is inside player
    }
    */
   // The original code had needsAnalysis flag.
}

std::set<std::shared_ptr<Player>> Game::getPlayersBetween(std::shared_ptr<Player> p1, std::shared_ptr<Player> p2) {
    std::set<std::shared_ptr<Player>> list;
    bool collecting = false;
    for (auto player : playersStatic) { // Order matters here, should probably use current turn order or fixed order
        // This logic depends on the seating arrangement which playersStatic might not represent correctly if it's just insertion order
        // Assuming playersStatic is the seating order.
        if (player == p1) {
            collecting = true;
            continue;
        }
        if (player == p2) {
            collecting = false;
            break;
        }
        if (collecting) {
            list.insert(player);
        }
    }
    // Handle wrap around if p2 appears before p1 in the list
    if (collecting) {
         for (auto player : playersStatic) {
            if (player == p2) {
                break;
            }
            list.insert(player);
         }
    }

    return list;
}

std::shared_ptr<std::vector<std::vector<std::string>>> Game::getTableInfo() {
    auto table = std::make_shared<std::vector<std::vector<std::string>>>();
    // TODO: Implement table info generation compatible with new types if needed
    return table;
}

u_int8_t Game::getNumberOfPlayers() {
    return (u_int8_t)playersStatic.size();
}

clue::GameStatus Game::toProto() const {
    clue::GameStatus status;
    // Populate Players
    for (const auto& p : playersStatic) {
        clue::Player* protoPlayer = status.add_players();
        protoPlayer->set_name(p->getName());
        protoPlayer->set_num_cards_in_hand(p->getNumCardsInHand());
        protoPlayer->set_solved(p->isPlayerSolved());

        for (const auto& card : *p->getHand()) {
            protoPlayer->add_hand(static_cast<clue::Card>(card.Value()));
        }
        for (const auto& card : *p->getNotInHand()) {
            protoPlayer->add_not_in_hand(static_cast<clue::Card>(card.Value()));
        }
    }

    // Populate Turns
    for (const auto& t : turns) {
        clue::Turn* protoTurn = status.add_turns();
        protoTurn->set_is_my_turn(t->getIsMyTurn());
        protoTurn->set_i_answered(t->getIAnswered());
        if (t->getPlayersTurn())
            protoTurn->set_players_turn_name(t->getPlayersTurn()->getName());

        protoTurn->set_suggestion_made(t->getAccusationSuspect() != Suspect::NONE); // Heuristic

        for (const auto& p : t->getPlayersWithoutCards()) {
            protoTurn->add_players_without_cards_names(p->getName());
        }

        protoTurn->set_suggestion_suspect(static_cast<clue::Suspect>(t->getAccusationSuspect().Value()));
        protoTurn->set_suggestion_weapon(static_cast<clue::Weapon>(t->getAccusationWeapon().Value()));
        protoTurn->set_suggestion_room(static_cast<clue::Room>(t->getAccusationRoom().Value()));

        if (t->getPlayerAnswered())
            protoTurn->set_player_answered_name(t->getPlayerAnswered()->getName());

        protoTurn->set_card_shown(static_cast<clue::Card>(t->getCardShown().Value()));
    }

    // Populate Lists
    for (const auto& s : getSuspectsList()) status.add_suspects_list(s);
    for (const auto& s : getWeaponsList()) status.add_weapons_list(s);
    for (const auto& s : getRoomsList()) status.add_rooms_list(s);
    for (const auto& s : getCardsList()) status.add_cards_list(s);

    return status;
}

const char* Game::PlayerNotFoundByName::what() noexcept {
    return "Player Not Found By Name";
}

} // namespace Clue
