#define CATCH_CONFIG_RUNNER
// stl
#include <string>
#include <iostream>
#include <vector>

// poco
#include <Poco/Net/SocketAddress.h>
#include <Poco/Net/StreamSocket.h>
// tcp server
#include <my_server.h>

#include <catch2/catch_all.hpp>

my_server::Server srv;
my_server::Server::Params params{32002, "0.0.0.0", my_server::Server::IP_VERSION::IPv4, my_server::HASH_TYPE::MD5};

const std::vector<std::string> vecInput = {
    R"(!@#$%^&*()_+-=?:;'"~`./|\.)",
    R"(hello, world)"
};

const std::vector<std::string> vecOutput = {
    "1229fa64773e3f8e8bbfe5183cf8a05a\n",
    "e4d7f1b4ed2e42d15898f4b27b019da4\n"
};


Poco::Net::StreamSocket createSocket()
{
    Poco::Net::SocketAddress sa("localhost", srv.getParams().port);
    return Poco::Net::StreamSocket(sa);
}

TEST_CASE( "MD5" )
{
    char buffer[33] = {0};
    auto socket = createSocket();
    for(std::size_t i = 0; i < vecInput.size(); ++i) {
        std::string input = vecInput[i] + "\n";
        socket.sendBytes(input.data(), static_cast<int>(input.size()));
        int n = socket.receiveBytes(buffer, sizeof(buffer));
        REQUIRE( vecOutput[i] == std::string(buffer, n) );
    }
}


int main( int argc, char* argv[] ) {
    srv.setParams(params);
    srv.start();

    int result = Catch::Session().run( argc, argv );

    srv.stop();

    return result;
}
