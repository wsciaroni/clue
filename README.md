# Clue Game Tracker

This project is a Clue game tracker application comprising a Flutter frontend and a C++ backend.

## Prerequisites

Before running the project, ensure you have the following installed:

### General
- Git

### Backend (C++)
- **CMake**: Version 3.25 or higher.
- **C++ Compiler**: Must support C++17 (e.g., GCC, Clang, MSVC).
- **Ninja (Optional)**: Recommended for faster builds.

### Frontend (Flutter)
- **Flutter SDK**: Version 3.10.4 or higher.
- **Dart SDK**: Included with Flutter.

## Backend

The backend is a C++ application located in `applications/backend`. It handles the core game logic and communication.

### Building

1.  **Create a build directory**:
    From the project root:
    ```bash
    mkdir build
    ```

2.  **Configure the project**:
    ```bash
    cmake -S . -B build
    ```
    *Tip: To use Ninja, add `-GNinja`: `cmake -S . -B build -GNinja`*

3.  **Build**:
    ```bash
    cmake --build build
    ```

### Running

After building, the executable will be located in the build directory.

```bash
./build/applications/backend/clue_backend
```

*Note: Currently, the backend application is a stub and will exit immediately upon running.*

## Frontend

The frontend is a Flutter application located in `applications/frontend`. It provides the user interface for tracking the game.

### Setup

1.  Navigate to the frontend directory:
    ```bash
    cd applications/frontend
    ```

2.  Install dependencies:
    ```bash
    flutter pub get
    ```

### Running

To run the application on a connected device or emulator:

```bash
flutter run
```

### Testing

To run the Flutter unit and widget tests:

```bash
flutter test
```

## Project Structure

- **`applications/`**: Contains the main application code.
    - **`backend/`**: C++ server application.
    - **`frontend/`**: Flutter client application.
- **`libraries/`**: Shared libraries and code.
    - **`corelib/`**: Core game logic and data structures.
    - **`messages/`**: Protobuf definitions (`clue.proto`) and generated C++ code.
