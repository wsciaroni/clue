#include <iostream>
#include <memory>
#include <string>
#include <unordered_map>
#include <mutex>
#include <sstream>
#include <iomanip>
#include <chrono>
#include <random>

#include <grpcpp/grpcpp.h>
#include "clue.grpc.pb.h"
#include "GameEngine.h"

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
using clue::ClueGameService;
using clue::InitGameRequest;
using clue::InitGameResponse;
using clue::TurnRequest;
using clue::TurnResponse;
using clue::DeductionRequest;
using clue::DeductionResponse;
using clue::GameEngine;

class ClueGameServiceImpl final : public ClueGameService::Service {
public:
  ClueGameServiceImpl() : rng(std::random_device{}()) {}

  // Handle InitGame RPC
  Status InitGame(ServerContext* context, const InitGameRequest* request,
                  InitGameResponse* reply) override {
    std::lock_guard<std::mutex> lock(mutex_);

    // Generate a unique game ID
    std::string game_id = generateUniqueGameId();
    std::cout << "Initializing new game with ID: " << game_id << std::endl;

    // Create a new GameEngine instance
    auto engine = std::make_unique<GameEngine>();
    engine->initialize(request->num_players(), {request->my_cards().begin(), request->my_cards().end()});

    // Store the game engine in the map
    games_[game_id] = std::move(engine);

    // Respond with the game ID
    reply->set_success(true);
    reply->set_game_id(game_id);
    return Status::OK;
  }

  // Handle RecordTurn RPC
  Status RecordTurn(ServerContext* context, const TurnRequest* request,
                    TurnResponse* reply) override {
    std::lock_guard<std::mutex> lock(mutex_);

    // Find the game engine for the given game ID
    auto it = games_.find(request->game_id());
    if (it == games_.end()) {
      reply->set_success(false);
      reply->set_error_message("Game ID not found");
      return Status(grpc::StatusCode::NOT_FOUND, "Game ID not found");
    }

    // auto& engine = it->second;

    // Process the turn
    // TODO: Call process_suggestion on the game engine
    // engine->process_suggestion(
    //   request->suggester(),
    //   request->suggestion_suspect(),
    //   request->suggestion_weapon(),
    //   request->suggestion_room(),
    //   request->responder(),
    //   request->has_shown_card() ? std::optional<clue::Card>(request->shown_card()) : std::nullopt
    // );

    reply->set_success(true);
    return Status::OK;
  }

  // Handle GetDeductions RPC
  Status GetDeductions(ServerContext* context, const DeductionRequest* request,
                       DeductionResponse* reply) override {
    std::lock_guard<std::mutex> lock(mutex_);

    // Find the game engine for the given game ID
    auto it = games_.find(request->game_id());
    if (it == games_.end()) {
      return Status(grpc::StatusCode::NOT_FOUND, "Game ID not found");
    }

    auto& engine = it->second;

    // Run the deduction logic
    engine->reconcile();

    return Status::OK;
  }

private:
  std::unordered_map<std::string, std::unique_ptr<GameEngine>> games_;
  std::mutex mutex_;
  std::mt19937 rng;

  // Generate a unique game ID
  std::string generateUniqueGameId() {
    std::ostringstream oss;
    auto now = std::chrono::system_clock::now();
    auto duration = now.time_since_epoch();
    auto millis = std::chrono::duration_cast<std::chrono::milliseconds>(duration).count();
    oss << "game_" << millis << "_" << std::setw(4) << std::setfill('0') << rng() % 10000;
    return oss.str();
  }
};

void RunServer() {
  std::string server_address("0.0.0.0:50051");
  ClueGameServiceImpl service;

  ServerBuilder builder;
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  builder.RegisterService(&service);
  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;

  server->Wait();
}

int main(int argc, char** argv) {
  RunServer();
  return 0;
}