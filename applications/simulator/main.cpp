#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <map>
#include <random>
#include <algorithm>
#include <sstream>
#include <memory>
#include <ctime>
#include <optional>

#include "GameEngine.h"
#include "clue.pb.h"

// Helper to split strings
std::vector<std::string> split(const std::string& str, char delimiter) {
    std::vector<std::string> tokens;
    std::string token;
    std::istringstream tokenStream(str);
    while (std::getline(tokenStream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

// Helper to convert enums to strings
std::string card_type_to_string(clue::CardType type) {
    switch (type) {
        case clue::CARD_TYPE_SUSPECT: return "Suspect";
        case clue::CARD_TYPE_WEAPON: return "Weapon";
        case clue::CARD_TYPE_ROOM: return "Room";
        default: return "Unknown";
    }
}

std::string card_to_string(const clue::Card& card) {
    std::string suffix;
    if (card.type() == clue::CARD_TYPE_SUSPECT) suffix = clue::Suspect_Name(card.suspect());
    else if (card.type() == clue::CARD_TYPE_WEAPON) suffix = clue::Weapon_Name(card.weapon());
    else if (card.type() == clue::CARD_TYPE_ROOM) suffix = clue::Room_Name(card.room());
    return suffix;
}

struct GameConfig {
    int num_players = 3;
    unsigned int seed = 0;
    std::string output_file = "game_log.json";
    int num_turns = 100;
};

class Simulator {
public:
    Simulator(const GameConfig& config) : m_config(config) {
        if (m_config.seed == 0) {
            m_rng.seed(std::time(nullptr));
        } else {
            m_rng.seed(m_config.seed);
        }
    }

    void run() {
        setup_game();

        std::ofstream out(m_config.output_file);
        out << "{\n";
        out << "  \"config\": {\n";
        out << "    \"num_players\": " << m_config.num_players << ",\n";
        out << "    \"seed\": " << m_config.seed << "\n";
        out << "  },\n";
        out << "  \"ground_truth\": {\n";
        out << "    \"case_file\": " << json_card_list(m_case_file) << ",\n";
        out << "    \"hands\": [\n";
        for (int i = 0; i < m_config.num_players; ++i) {
            out << "      " << json_card_list(m_hands[i]) << (i < m_config.num_players - 1 ? "," : "") << "\n";
        }
        out << "    ]\n";
        out << "  },\n";
        out << "  \"turns\": [\n";

        for (int turn = 0; turn < m_config.num_turns; ++turn) {
            if (is_game_solved()) {
                std::cout << "Game solved at turn " << turn << std::endl;
                break;
            }

            simulate_turn(out, turn);
            if (turn < m_config.num_turns - 1 && !is_game_solved()) {
                out << ",\n";
            }
        }

        out << "\n  ]\n";
        out << "}\n";
        out.close();
    }

private:
    GameConfig m_config;
    std::mt19937 m_rng;

    std::vector<clue::Card> m_all_cards;
    std::vector<clue::Card> m_case_file;
    std::vector<std::vector<clue::Card>> m_hands;

    std::vector<std::unique_ptr<clue::GameEngine>> m_player_engines;

    void setup_game() {
        // Create deck
        create_deck();

        // Separate Case File
        std::vector<clue::Card> suspects, weapons, rooms;
        for (const auto& c : m_all_cards) {
            if (c.type() == clue::CARD_TYPE_SUSPECT) suspects.push_back(c);
            else if (c.type() == clue::CARD_TYPE_WEAPON) weapons.push_back(c);
            else if (c.type() == clue::CARD_TYPE_ROOM) rooms.push_back(c);
        }

        std::shuffle(suspects.begin(), suspects.end(), m_rng);
        std::shuffle(weapons.begin(), weapons.end(), m_rng);
        std::shuffle(rooms.begin(), rooms.end(), m_rng);

        m_case_file.push_back(suspects.back()); suspects.pop_back();
        m_case_file.push_back(weapons.back()); weapons.pop_back();
        m_case_file.push_back(rooms.back()); rooms.pop_back();

        // Combine rest
        std::vector<clue::Card> deck;
        deck.insert(deck.end(), suspects.begin(), suspects.end());
        deck.insert(deck.end(), weapons.begin(), weapons.end());
        deck.insert(deck.end(), rooms.begin(), rooms.end());
        std::shuffle(deck.begin(), deck.end(), m_rng);

        // Deal
        m_hands.resize(m_config.num_players);
        int p = 0;
        for (const auto& c : deck) {
            m_hands[p].push_back(c);
            p = (p + 1) % m_config.num_players;
        }

        // Initialize Engines
        for (int i = 0; i < m_config.num_players; ++i) {
            auto engine = std::make_unique<clue::GameEngine>();
            clue::InitGameRequest request;
            request.set_num_players(m_config.num_players);
            for (int j=0; j < m_config.num_players; j++) {
                request.add_player_names("Player " + std::to_string(j));
            }
            // For the current engine 'i', we only know its own hand
            for (const auto& c : m_hands[i]) {
                *request.add_my_hand() = c;
            }
            engine->initialize_game(request);
            m_player_engines.push_back(std::move(engine));
        }
    }

    void create_deck() {
        // Hardcoded based on enum values in clue.proto
        // Suspects 1-6
        for(int i=1; i<=6; ++i) {
            clue::Card c; c.set_type(clue::CARD_TYPE_SUSPECT); c.set_suspect((clue::Suspect)i);
            m_all_cards.push_back(c);
        }
        // Weapons 1-6
        for(int i=1; i<=6; ++i) {
            clue::Card c; c.set_type(clue::CARD_TYPE_WEAPON); c.set_weapon((clue::Weapon)i);
            m_all_cards.push_back(c);
        }
        // Rooms 1-9
        for(int i=1; i<=9; ++i) {
            clue::Card c; c.set_type(clue::CARD_TYPE_ROOM); c.set_room((clue::Room)i);
            m_all_cards.push_back(c);
        }
    }

    bool is_game_solved() {
        // Check if any player engine has solved the case file (3 cards known true in case file)
        for (const auto& engine : m_player_engines) {
            // New way: iterate through solution probabilities or rows to check what's eliminated
            auto state = engine->get_game_state_response();
            int solved_count = 0;

            // In get_game_state_response, we have solution_probabilities
            // A card is "solved" (part of the case file) if its probability is 1.0?
            // Or if it's the only one left in its category.
            // The memory says "get_case_file_state(id) == clue::CardState::KNOWN_TRUE" was the old check.

            // Let's use solution_probabilities from GameStateResponse
            for (const auto& prob : state.solution_probabilities()) {
                // If it's NOT eliminated, it might be the solution.
                // But how do we know if it is definitively the solution?
                // The old code checked for KNOWN_TRUE in case file state.
                // The new GameEngine likely doesn't expose raw state directly.
                // However, if we have exactly 1 suspect, 1 weapon, 1 room not eliminated, we are solved.
                // Or if the probability is 100% (if implemented).

                // Alternatively, I can check if 'is_eliminated' is false. If only 3 cards (1 per type) remain un-eliminated, it's solved.
                // But let's look at `rows`. It contains player states.
                // The `solution_probabilities` message seems to be specifically for the case file.
                // Let's assume `is_eliminated` is populated.

                // Wait, `SolutionProbability` has a `probability` field. If it's 1.0, it's the card.
                // Let's count cards with probability > 0.99 (float safety).
                if (prob.probability() > 0.99f) {
                    solved_count++;
                }
            }

            if (solved_count == 3) return true;
        }
        return false;
    }

    void simulate_turn(std::ofstream& out, int turn_idx) {
        int suggester_idx = turn_idx % m_config.num_players;

        // Make a random suggestion
        clue::Card suspect = get_random_card(clue::CARD_TYPE_SUSPECT);
        clue::Card weapon = get_random_card(clue::CARD_TYPE_WEAPON);
        clue::Card room = get_random_card(clue::CARD_TYPE_ROOM);

        // Determine responder
        int responder_idx = -1;
        clue::Card response_card;
        bool has_response = false;

        for (int offset = 1; offset < m_config.num_players; ++offset) {
            int p_idx = (suggester_idx + offset) % m_config.num_players;
            std::vector<clue::Card> matches;
            for (const auto& c : m_hands[p_idx]) {
                if (cards_equal(c, suspect) || cards_equal(c, weapon) || cards_equal(c, room)) {
                    matches.push_back(c);
                }
            }
            if (!matches.empty()) {
                responder_idx = p_idx;
                std::shuffle(matches.begin(), matches.end(), m_rng);
                response_card = matches[0];
                has_response = true;
                break;
            }
        }

        // Update Engines
        update_engines(suggester_idx, suspect, weapon, room, responder_idx, response_card, has_response);

        // Output Turn
        out << "    {\n";
        out << "      \"turn\": " << turn_idx << ",\n";
        out << "      \"suggester\": " << suggester_idx << ",\n";
        out << "      \"suggestion\": [" << json_card(suspect) << ", " << json_card(weapon) << ", " << json_card(room) << "],\n";
        out << "      \"responder\": " << responder_idx << ",\n";
        if (has_response) {
            out << "      \"response_card_ground_truth\": " << json_card(response_card) << ",\n";
        }
        out << "      \"knowledge\": [\n";
        for (int i = 0; i < m_config.num_players; ++i) {
             out << "        " << get_knowledge_json(i) << (i < m_config.num_players - 1 ? "," : "") << "\n";
        }
        out << "      ]\n";
        out << "    }";
    }

    void update_engines(int suggester_idx, const clue::Card& s, const clue::Card& w, const clue::Card& r,
                        int responder_idx, const clue::Card& response_card, bool has_response) {

        for (int i = 0; i < m_config.num_players; ++i) {
             // For Player i, what did they see?
             clue::TurnData turn_data;
             turn_data.set_suggester_player_index(suggester_idx);
             *turn_data.mutable_suspect() = s;
             *turn_data.mutable_weapon() = w;
             *turn_data.mutable_room() = r;
             turn_data.set_responder_player_index(responder_idx);

             if (has_response) {
                 if (i == suggester_idx) {
                     // I made the suggestion, I saw the card
                     *turn_data.mutable_card_shown() = response_card;
                 } else if (i == responder_idx) {
                     // I showed the card, so I know what I showed (redundant but consistent)
                     *turn_data.mutable_card_shown() = response_card;
                 }
                 // Others see nothing (card_shown remains unset)
             } else {
                 // No one responded
                 turn_data.set_responder_player_index(-1);
             }

             // Update engine
             m_player_engines[i]->record_turn(turn_data);
        }
    }

    std::string get_knowledge_json(int player_idx) {
        // Extract what this player knows about the case file
        std::stringstream ss;
        ss << "{ \"player\": " << player_idx << ", \"case_file_probabilities\": {";

        std::vector<std::string> suspects, weapons, rooms;

        auto state = m_player_engines[player_idx]->get_game_state_response();
        // Iterate over solution probabilities to see what is NOT eliminated
        for (const auto& prob : state.solution_probabilities()) {
             if (!prob.is_eliminated()) {
                 std::string name = card_to_string(prob.card());
                 if (prob.card().type() == clue::CARD_TYPE_SUSPECT) suspects.push_back(name);
                 else if (prob.card().type() == clue::CARD_TYPE_WEAPON) weapons.push_back(name);
                 else if (prob.card().type() == clue::CARD_TYPE_ROOM) rooms.push_back(name);
             }
        }

        ss << "\"suspects\": [";
        for(size_t i=0; i<suspects.size(); ++i) ss << "\"" << suspects[i] << "\"" << (i<suspects.size()-1?",":"");
        ss << "], \"weapons\": [";
        for(size_t i=0; i<weapons.size(); ++i) ss << "\"" << weapons[i] << "\"" << (i<weapons.size()-1?",":"");
        ss << "], \"rooms\": [";
        for(size_t i=0; i<rooms.size(); ++i) ss << "\"" << rooms[i] << "\"" << (i<rooms.size()-1?",":"");
        ss << "]}}";

        return ss.str();
    }

    clue::CardId get_card_id(const clue::Card& c) {
        clue::CardId id;
        id.type = c.type();
        if (id.type == clue::CARD_TYPE_SUSPECT) id.id = c.suspect();
        else if (id.type == clue::CARD_TYPE_WEAPON) id.id = c.weapon();
        else if (id.type == clue::CARD_TYPE_ROOM) id.id = c.room();
        return id;
    }

    clue::Card get_random_card(clue::CardType type) {
        std::vector<clue::Card> candidates;
        for (const auto& c : m_all_cards) {
            if (c.type() == type) candidates.push_back(c);
        }
        std::uniform_int_distribution<> dist(0, candidates.size() - 1);
        return candidates[dist(m_rng)];
    }

    bool cards_equal(const clue::Card& a, const clue::Card& b) {
        if (a.type() != b.type()) return false;
        if (a.type() == clue::CARD_TYPE_SUSPECT) return a.suspect() == b.suspect();
        if (a.type() == clue::CARD_TYPE_WEAPON) return a.weapon() == b.weapon();
        if (a.type() == clue::CARD_TYPE_ROOM) return a.room() == b.room();
        return false;
    }

    std::string json_card(const clue::Card& c) {
        return "\"" + card_to_string(c) + "\"";
    }

    std::string json_card_list(const std::vector<clue::Card>& list) {
        std::stringstream ss;
        ss << "[";
        for (size_t i = 0; i < list.size(); ++i) {
            ss << json_card(list[i]);
            if (i < list.size() - 1) ss << ", ";
        }
        ss << "]";
        return ss.str();
    }
};

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <config_file>" << std::endl;
        return 1;
    }

    GameConfig config;
    std::ifstream cfg(argv[1]);
    std::string line;
    while (std::getline(cfg, line)) {
        if (line.empty() || line[0] == '#') continue;
        auto parts = split(line, '=');
        if (parts.size() == 2) {
            if (parts[0] == "num_players") config.num_players = std::stoi(parts[1]);
            else if (parts[0] == "seed") config.seed = std::stoul(parts[1]);
            else if (parts[0] == "output") config.output_file = parts[1];
            else if (parts[0] == "turns") config.num_turns = std::stoi(parts[1]);
        }
    }

    Simulator sim(config);
    sim.run();

    return 0;
}
