#ifndef CLUE_GAME_SERVICE_IMPL_H
#define CLUE_GAME_SERVICE_IMPL_H

#include "clue.grpc.pb.h"
#include "GameEngine.h"
#include <memory>
#include <mutex>
#include <map>
#include <string>
#include <chrono>
#include <thread>
#include <atomic>
#include <condition_variable>

class ClueGameServiceImpl final : public clue::ClueGameService::Service {
public:
    // Default: 1 hour timeout, check every 1 minute
    ClueGameServiceImpl(std::chrono::milliseconds game_timeout = std::chrono::hours(1),
                        std::chrono::milliseconds cleanup_interval = std::chrono::minutes(1));
    ~ClueGameServiceImpl() override;

    grpc::Status InitGame(grpc::ServerContext* context, const clue::InitGameRequest* request,
                          clue::InitGameResponse* response) override;

    grpc::Status RecordTurn(grpc::ServerContext* context, const clue::TurnRequest* request,
                            clue::TurnResponse* response) override;

    grpc::Status UpdateTurn(grpc::ServerContext* context, const clue::UpdateTurnRequest* request,
                            clue::TurnResponse* response) override;

    grpc::Status DeleteTurn(grpc::ServerContext* context, const clue::DeleteTurnRequest* request,
                            clue::DeleteTurnResponse* response) override;

    grpc::Status UndoLastTurn(grpc::ServerContext* context, const clue::UndoRequest* request,
                              clue::UndoResponse* response) override;

    grpc::Status GetTurnHistory(grpc::ServerContext* context, const clue::GetHistoryRequest* request,
                                clue::GetHistoryResponse* response) override;

    grpc::Status GetGameState(grpc::ServerContext* context, const clue::GameStateRequest* request,
                              clue::GameStateResponse* response) override;

    grpc::Status GetNextMoves(grpc::ServerContext* context, const clue::GetNextMovesRequest* request,
                              clue::GetNextMovesResponse* response) override;

    grpc::Status GetAccusationRecommendation(grpc::ServerContext* context, const clue::GetAccusationRecommendationRequest* request,
                                             clue::GetAccusationRecommendationResponse* response) override;

private:
    struct GameSession {
        std::shared_ptr<clue::GameEngine> engine;
        std::chrono::steady_clock::time_point last_activity;
    };

    std::mutex m_mutex;
    std::map<std::string, GameSession> m_games;

    // Cleanup handling
    std::chrono::milliseconds m_timeout;
    std::chrono::milliseconds m_cleanup_interval;
    std::thread m_cleanup_thread;
    std::atomic<bool> m_stop_cleanup;
    std::condition_variable m_cv;
    std::mutex m_cv_mutex;

    void cleanup_loop();
    std::shared_ptr<clue::GameEngine> get_game(const std::string& game_id);
    std::string generate_game_id();
};

#endif // CLUE_GAME_SERVICE_IMPL_H
