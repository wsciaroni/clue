# Clue Game Messages & Service

This directory contains the Protocol Buffers definition for the Clue game logic.
It defines the messages used to communicate between the frontend and the backend, and the `GameService` which exposes the game logic via gRPC.

## `clue.proto`

### Messages
- **Player**: Represents a player in the game, including their hand and known cards.
- **Turn**: Represents a single turn, including who's turn it is, any suggestions made, and cards shown.
- **GameStatus**: Represents the full state of the game, including all players, turns, and lists of suspects/weapons/rooms.

### Service: `GameService`
- **CreateGame(CreateGameRequest)**: Initializes a new game with the given player names and the local player's hand.
- **SubmitTurn(Turn)**: Submits a turn to the game logic. The backend will process the turn and update player states (deductions).
- **GetGameState(Empty)**: Retrieves the current state of the game.
- **GetPlayer(PlayerRequest)**: Retrieves details about a specific player.

## Usage

1.  **Build**: The project uses CMake to generate the C++ code from `clue.proto`.
2.  **Server**: The backend implements `GameServiceImpl` (in `src/core`) which wraps the `Clue::Game` logic.
3.  **Client**: The frontend (e.g., Flutter) should generate client code from `clue.proto` and call the service methods.

## Enums
The enums `Suspect`, `Weapon`, `Room`, and `Card` match the internal definitions in `src/core/include/clue/constants.h`.
