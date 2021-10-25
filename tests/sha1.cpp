#define CATCH_CONFIG_RUNNER
// stl
#include <string>
#include <iostream>
#include <vector>

// poco
#include <Poco/Net/SocketAddress.h>
#include <Poco/Net/StreamSocket.h>
// tcp server
#include <hash_server.h>

#include <catch2/catch_all.hpp>

hash_server::HashServer srv;
hash_server::HashServer::Params params{32001, "0.0.0.0", hash_server::HashServer::IP_VERSION::IPv4, hash_server::HashServer::HASH_TYPE::SHA1};

const std::vector<std::string> vecInput = {
    R"(Hello, World!)",
    R"(!@#$%^&*()_+-=?:;'"~`./|\.)"
};

const std::vector<std::string> vecOutput = {
    "0a0a9f2a6772942557ab5355d76af442f8f65e01\n",
    "c8530d408006e05f3fc82d9ef80057cc1ec36554\n"
};


Poco::Net::StreamSocket createSocket()
{
    Poco::Net::SocketAddress sa("localhost", srv.getParams().port);
    return Poco::Net::StreamSocket(sa);
}

TEST_CASE( "SHA1" )
{
    char buffer[41] = {0};
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
