# NetworkOptix

## Dependencies
Windows 10
1. [cmake](https://cmake.org/download/)
2. [ninja](https://github.com/ninja-build/ninja/releases)  + add PATH(C:\ninja)
3. [git](https://git-scm.com/downloads)
4. [msvc 2019](https://visualstudio.microsoft.com/ru/downloads/)
5. [poco](https://pocoproject.org/download.html)
```bat
mkdir C:\poco_src && cd C:\poco_src
git clone -b master https://github.com/pocoproject/poco.git
git submodule update --init --recursive --force
mkdir C:\poco_build && cd C:\poco_build
mkdir C:\poco
cmake -G "Visual Studio 16 2019" -A x64 -DCMAKE_BUILD_TYPE:STRING=Release -S "C:\poco_src" -B "C:\poco_build" -DCMAKE_INSTALL_PREFIX:STRING="C:\poco"
add environment variable Poco_DIR=C:\poco
add PATH %Poco_DIR%\bin
```


Ubuntu 16
```sh
cd /home/user
sudo apt update
sudo apt install -y make gcc g++ ninja-build curl vim libssl-dev cmake
## cmake
CMAKE_VERSION=3.21.3
wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz \
&& tar -xzf cmake-$CMAKE_VERSION.tar.gz \
&& cd cmake-$CMAKE_VERSION \
&& ./bootstrap -- -DCMAKE_BUILD_TYPE:STRING=Release \
&& make \
&& sudo make install \
&& cd ../ \
&& rm -rf cmake-$CMAKE_VERSION.tar.gz cmake-$CMAKE_VERSION \
&& sudo apt purge cmake && sudo apt autoremove \
&& hash -d cmake
# cmake --version ---> 3.21.3
## git
GIT_VERSION=2.26.2
cd /home/user \
&& sudo apt install libz-dev libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext \
&& curl -o git.tar.gz https://mirrors.edge.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz \
&& tar -zxf git.tar.gz \
&& git-$GIT_VERSION/ \
&& make prefix=/usr all \
&& sudo make prefix=/usr install
# git --version ---> 2.26.2
## Poco
git clone -b master https://github.com/pocoproject/poco.git \
&& git submodule update --init --recursive --force \
&& poco cd ../ \
&& mkdir poco_build \
&& cd poco_build/ \
&& cmake -G Ninja -S ../poco -B . -DCMAKE_BUILD_TYPE:STRING=Release \
&& cmake --build . --target install \
&& rm -rf poco/ poco_build/ \
## Clang
CLANG_VERSION=12
sudo apt install -y cppcheck clang-tidy-$CLANG_VERSION \
&& wget https://apt.llvm.org/llvm.sh \
&& ./llvm.sh $CLANG_VERSION \
&& rm -f llvm.sh \
&& update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$CLANG_VERSION 10 \
&& update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-$CLANG_VERSION 10 \
```


## Build and Run
```sh
git clone https://github.com/LLlKuIIeP/NetworkOptix
cd NetworkOptix
git submodule update --init --recursive --force
cd ../
mkdir build
cd build
### Ubuntu
# GCC
cmake -G Ninja -S ../NetworkOptix/ -B . -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_CXX_COMPILER=/usr/bin/g++
# Clang
cmake -G Ninja -S ../NetworkOptix/ -B . -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
cmake --build . -j $(nproc)
### Windows
cmake -G Ninja -S ../NetworkOptix/ -B . -DCMAKE_BUILD_TYPE:STRING=Release
cmake --build . -- /m
```
