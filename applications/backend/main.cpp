#include <iostream>
#include <memory>
#include <string>

#include <grpcpp/grpcpp.h>
#include "clue.grpc.pb.h"

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

// Logic and data behind the server's behavior.
class ClueGameServiceImpl final : public ClueGameService::Service {
public:
  // Handle InitGame RPC
  Status InitGame(ServerContext* context, const InitGameRequest* request,
                  InitGameResponse* reply) override {
    std::cout << "Initializing game with " << request->num_players() << " players." << std::endl;

    // Log player names
    for (const auto& player : request->player_names()) {
      std::cout << "Player: " << player << std::endl;
    }

    // Log cards
    for (const auto& card : request->my_cards()) {
      std::cout << "Card: " << card.name() << " (" << card.type() << ")" << std::endl;
    }

    // Generate a dummy game ID and return success
    reply->set_success(true);
    reply->set_game_id("game_12345");
    return Status::OK;
  }

  // Handle RecordTurn RPC
  Status RecordTurn(ServerContext* context, const TurnRequest* request,
                    TurnResponse* reply) override {
    std::cout << "Recording turn for suggester: " << request->suggester() << std::endl;
    std::cout << "Suggestion - Suspect: " << request->suggestion_suspect().name()
              << ", Weapon: " << request->suggestion_weapon().name()
              << ", Room: " << request->suggestion_room().name() << std::endl;

    if (!request->responder().empty()) {
      std::cout << "Responder: " << request->responder() << std::endl;
    }

    if (request->has_shown_card()) {
      std::cout << "Card shown: " << request->shown_card().name() << std::endl;
    }

    // Return success
    reply->set_success(true);
    return Status::OK;
  }

  // Handle GetDeductions RPC
  Status GetDeductions(ServerContext* context, const DeductionRequest* request,
                       DeductionResponse* reply) override {
    std::cout << "Fetching deductions for game ID: " << request->game_id() << std::endl;

    return Status::OK;
  }
};

void RunServer() {
  std::string server_address("0.0.0.0:50051");
  ClueGameServiceImpl service;

  ServerBuilder builder;
  // Listen on the given address without any authentication mechanism.
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  // Register "service" as the instance through which we'll communicate with clients.
  builder.RegisterService(&service);
  // Finally assemble the server.
  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;

  // Wait for the server to shutdown.
  server->Wait();
}

int main(int argc, char** argv) {
  RunServer();
  return 0;
}