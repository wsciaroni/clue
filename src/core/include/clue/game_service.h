#pragma once

#include "clue.grpc.pb.h"
#include "clue/game.h"
#include <memory>
#include <mutex>

namespace Clue {

class GameServiceImpl final : public clue::GameService::Service {
public:
    GameServiceImpl();

    grpc::Status CreateGame(grpc::ServerContext* context, const clue::CreateGameRequest* request, clue::GameStatus* response) override;
    grpc::Status SubmitTurn(grpc::ServerContext* context, const clue::Turn* request, clue::GameStatus* response) override;
    grpc::Status GetGameState(grpc::ServerContext* context, const clue::Empty* request, clue::GameStatus* response) override;
    grpc::Status GetPlayer(grpc::ServerContext* context, const clue::PlayerRequest* request, clue::Player* response) override;

private:
    std::shared_ptr<Game> game;
    std::mutex gameMutex;
};

} // namespace Clue
