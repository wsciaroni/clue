#include "ClueGameServiceImpl.h"
#include <iostream>
#include <random>
#include <sstream>

ClueGameServiceImpl::ClueGameServiceImpl() {}

std::string ClueGameServiceImpl::generate_game_id() {
    static std::random_device rd;
    static std::mt19937 gen(rd());
    static std::uniform_int_distribution<> dis(0, 15);
    std::stringstream ss;
    for (int i = 0; i < 8; ++i) {
        int rc = dis(gen);
        ss << std::hex << rc;
    }
    return ss.str();
}

std::shared_ptr<clue::GameEngine> ClueGameServiceImpl::get_game(const std::string& game_id) {
    auto it = m_games.find(game_id);
    if (it != m_games.end()) {
        return it->second;
    }
    return nullptr;
}

grpc::Status ClueGameServiceImpl::InitGame(grpc::ServerContext* context, const clue::InitGameRequest* request,
                                           clue::InitGameResponse* response) {
    std::lock_guard<std::mutex> lock(m_mutex);
    try {
        std::string new_id = generate_game_id();
        auto engine = std::make_shared<clue::GameEngine>();
        engine->initialize_game(*request);
        m_games[new_id] = engine;

        response->set_success(true);
        response->set_game_id(new_id);
    } catch (const std::exception& e) {
        response->set_success(false);
        response->set_error_message(e.what());
    }
    return grpc::Status::OK;
}

grpc::Status ClueGameServiceImpl::RecordTurn(grpc::ServerContext* context, const clue::TurnRequest* request,
                                             clue::TurnResponse* response) {
    std::lock_guard<std::mutex> lock(m_mutex);
    auto engine = get_game(request->game_id());
    if (!engine) {
        response->set_success(false);
        response->set_error_message("Game not found: " + request->game_id());
        return grpc::Status::OK;
    }

    try {
        engine->record_turn(request->data());
        response->set_success(true);
    } catch (const std::exception& e) {
        response->set_success(false);
        response->set_error_message(e.what());
    }
    return grpc::Status::OK;
}

grpc::Status ClueGameServiceImpl::UpdateTurn(grpc::ServerContext* context, const clue::UpdateTurnRequest* request,
                                             clue::TurnResponse* response) {
    std::lock_guard<std::mutex> lock(m_mutex);
    auto engine = get_game(request->game_id());
    if (!engine) {
        response->set_success(false);
        response->set_error_message("Game not found");
        return grpc::Status::OK;
    }

    if (engine->update_turn(request->turn_id(), request->new_data())) {
        response->set_success(true);
    } else {
        response->set_success(false);
        response->set_error_message("Turn not found");
    }
    return grpc::Status::OK;
}

grpc::Status ClueGameServiceImpl::UndoLastTurn(grpc::ServerContext* context, const clue::UndoRequest* request,
                                               clue::UndoResponse* response) {
    std::lock_guard<std::mutex> lock(m_mutex);
    auto engine = get_game(request->game_id());
    if (!engine) {
        response->set_success(false);
        return grpc::Status::OK;
    }

    response->set_success(engine->undo_last_turn());
    return grpc::Status::OK;
}

grpc::Status ClueGameServiceImpl::GetTurnHistory(grpc::ServerContext* context, const clue::GetHistoryRequest* request,
                                                 clue::GetHistoryResponse* response) {
    std::lock_guard<std::mutex> lock(m_mutex);
    auto engine = get_game(request->game_id());
    if (!engine) {
        return grpc::Status::OK; // Or error
    }

    auto history = engine->get_history();
    for (const auto& entry : history) {
        *response->add_history() = entry;
    }
    return grpc::Status::OK;
}

grpc::Status ClueGameServiceImpl::GetGameState(grpc::ServerContext* context, const clue::GameStateRequest* request,
                                               clue::GameStateResponse* response) {
    std::lock_guard<std::mutex> lock(m_mutex);
    auto engine = get_game(request->game_id());
    if (!engine) {
        return grpc::Status::OK;
    }

    *response = engine->get_game_state_response();
    return grpc::Status::OK;
}
