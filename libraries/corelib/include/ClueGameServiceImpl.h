#ifndef CLUE_GAME_SERVICE_IMPL_H
#define CLUE_GAME_SERVICE_IMPL_H

#include "clue.grpc.pb.h"
#include "GameEngine.h"
#include <memory>
#include <mutex>
#include <map>
#include <string>

class ClueGameServiceImpl final : public clue::ClueGameService::Service {
public:
    ClueGameServiceImpl();

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
    std::mutex m_mutex;
    std::map<std::string, std::shared_ptr<clue::GameEngine>> m_games;

    std::shared_ptr<clue::GameEngine> get_game(const std::string& game_id);
    std::string generate_game_id();
};

#endif // CLUE_GAME_SERVICE_IMPL_H
