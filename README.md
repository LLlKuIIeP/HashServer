# Hash Server

A TCP server project that computes the hash of a string. The server opens a port and accepts lines separated by a newline character. The result of the hash string operation in hexadecimal format.

- [Dependencies](#dependencies)
- [Get sources](#get-sources)
- [Configure](#configure)
- [Build](#build)
- [License](#license)


## Dependencies

[CMake](https://github.com/Kitware/CMake) version 3.21.3 or later.

[Poco](https://github.com/pocoproject/poco) version 1.11.0 or later.</br>
Example of installing Poco from source in custom direcroty ```/opt/poco```
```sh
# Poco Dependencies
sudo apt update
sudo apt install -y git g++ make cmake libssl-dev ninja-build

# Install
sudo mkdir /opt/poco
cd ~
git clone -b master https://github.com/pocoproject/poco.git poco
cd poco
git submodule update --init --recursive
cd ..
mkdir poco_build
cd poco_build
cmake -G Ninja -S ../poco -B . -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX=/opt/poco
sudo cmake --build . --target install
rm -rf poco/ poco_build/

echo 'export Poco_DIR=/opt/poco' >> .bashrc
source .bashrc
```


## Get sources

```sh
git clone https://github.com/LLlKuIIeP/HashServer
cd HashServer
git submodule update --init --recursive
```


## Configure

```sh
mkdir build
cd build
cmake -G Ninja -S <path_to_source>/ -B . -DCMAKE_BUILD_TYPE:STRING=Release
```


## Build

#### Windows 10

```bat
cmake --build . -- /m
```

#### Ubuntu 16
```sh
cmake --build . -j $(nproc)
```


## License

<img align="right" src="https://opensource.org/trademarks/opensource/OSI-Approved-License-100x137.png">

The class is licensed under the [MIT License](https://opensource.org/licenses/MIT):

Copyright &copy; 2021-2021 Sergey Abramov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
