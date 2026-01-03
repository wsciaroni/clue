# Start with the official Microsoft C++ Dev image (Debian 12 based)
FROM mcr.microsoft.com/devcontainers/cpp:1-debian-12

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install dependencies
# Added 'curl', 'git', 'unzip', 'xz-utils', 'zip' which Flutter needs
# use wget to grab google chrome as well
# fonts-liberation, libasound2, libvulkan1, xdg-utils are all needed to install google chrome
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
    fonts-liberation \
    libasound2 \
    libvulkan1 \
    xdg-utils \
    curl git unzip xz-utils zip libglu1-mesa \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Set Clang as the default compiler
ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++

# 2. Install Flutter Manually (Bypassing the failing Feature)
# We clone the stable branch directly into a system folder
RUN git clone https://github.com/flutter/flutter.git -b stable /sdks/flutter

# 3. Add Flutter to PATH for all users
ENV PATH="/sdks/flutter/bin:${PATH}"

# 4. Set ownership of the flutter directory to the 'vscode' user
# This ensures you can run 'flutter pub get' without permission errors
RUN chown -R vscode:vscode /sdks/flutter

# Revert to dialog for any interactive tools run later
ENV DEBIAN_FRONTEND=dialog