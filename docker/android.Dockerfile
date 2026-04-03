FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/usr/local/android
ENV ANDROID_NDK_HOME=/usr/local/android/android-ndk-r21e
ENV ANDROID_SDK_ROOT=/usr/local/android
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/platform-tools

ENV ANDROID_DEPS_ARM64_V8A=/usr/local/android/deps-arm64-v8a
ENV ANDROID_DEPS_ARMEABI_V7A=/usr/local/android/deps-armeabi-v7a

RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    cmake \
    git \
    wget \
    unzip \
    openjdk-8-jdk-headless \
    libncurses5 \
    python3 \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/android

# Android NDK
RUN wget https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip --no-check-certificate && \
    unzip android-ndk-r21e-linux-x86_64.zip && \
    rm android-ndk-r21e-linux-x86_64.zip

# Android SDK command-line tools
RUN mkdir -p cmdline-tools
WORKDIR /usr/local/android/cmdline-tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip --no-check-certificate && \
    unzip commandlinetools-linux-6609375_latest.zip && \
    rm commandlinetools-linux-6609375_latest.zip

WORKDIR /usr/local/android/cmdline-tools/tools/bin
RUN yes | ./sdkmanager "platforms;android-26" && \
    yes | ./sdkmanager "platform-tools" && \
    yes | ./sdkmanager "build-tools;29.0.2" && \
    yes | ./sdkmanager "cmake;3.10.2.4988404"

# Cross-compiled SDL2 deps
WORKDIR /usr/local/android
RUN mkdir -p deps-armeabi-v7a/SDL2 deps-arm64-v8a/SDL2

RUN wget https://www.libsdl.org/release/SDL2-2.0.14.tar.gz --no-check-certificate && \
    tar -xzf SDL2-2.0.14.tar.gz && \
    rm SDL2-2.0.14.tar.gz

WORKDIR /usr/local/android/SDL2-2.0.14
RUN mkdir build-armeabi-v7a
WORKDIR /usr/local/android/SDL2-2.0.14/build-armeabi-v7a
RUN cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=$ANDROID_DEPS_ARMEABI_V7A/SDL2 \
    -DSDL_STATIC=ON \
    -DSDL_SHARED=OFF \
    -DANDROID_ABI=armeabi-v7a \
    -DANDROID_PLATFORM=android-15
RUN cmake --build . --target install -j4

WORKDIR /usr/local/android/SDL2-2.0.14
RUN mkdir build-arm64-v8a
WORKDIR /usr/local/android/SDL2-2.0.14/build-arm64-v8a
RUN cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=$ANDROID_DEPS_ARM64_V8A/SDL2 \
    -DSDL_STATIC=ON \
    -DSDL_SHARED=OFF \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-15
RUN cmake --build . --target install -j4

WORKDIR /usr/local/android
RUN rm -rf SDL2-2.0.14

WORKDIR /work