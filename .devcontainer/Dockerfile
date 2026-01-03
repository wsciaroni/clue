# Start with the official Microsoft C++ Dev image (Debian 12 based)
FROM mcr.microsoft.com/devcontainers/cpp:1-debian-12

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install dependencies
# Added 'curl', 'git', 'unzip', 'xz-utils', 'zip' which Flutter needs
RUN apt-get update && apt-get install -y \
    protobuf-compiler \
    libprotobuf-dev \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev \
    clang \
    lldb \
    llvm \
    curl git unzip xz-utils zip libglu1-mesa \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Set Clang as the default compiler
ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++
