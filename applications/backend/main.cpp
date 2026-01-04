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
using clue::GameStatusRequest;
using clue::GameStatusResponse;

// Logic and data behind the server's behavior.
class ClueGameServiceImpl final : public ClueGameService::Service {
  Status GetGameStatus(ServerContext* context, const GameStatusRequest* request,
                       GameStatusResponse* reply) override {
    std::string game_id = request->game_id();
    std::cout << "Received request for game_id: " << game_id << std::endl;

    // For now, return a dummy status
    reply->set_status("Game In Progress");
    reply->set_is_active(true);

    return Status::OK;
  }
};

void RunServer() {
  std::string server_address("0.0.0.0:50051");
  ClueGameServiceImpl service;

  ServerBuilder builder;
  // Listen on the given address without any authentication mechanism.
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  // Register "service" as the instance through which we'll communicate with
  // clients. In this case it corresponds to an *synchronous* service.
  builder.RegisterService(&service);
  // Finally assemble the server.
  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;

  // Wait for the server to shutdown. Note that some other thread must be
  // responsible for shutting down the server for this call to ever return.
  server->Wait();
}

int main(int argc, char** argv) {
  RunServer();
  return 0;
}
