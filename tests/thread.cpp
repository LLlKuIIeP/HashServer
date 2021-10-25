#define CATCH_CONFIG_RUNNER
// stl
#include <iostream>
#include <thread>

// poco
#include <Poco/Net/SocketAddress.h>
#include <Poco/Net/StreamSocket.h>
// tcp server
#include <hash_server.h>

#include <catch2/catch_all.hpp>

hash_server::HashServer srv;
hash_server::HashServer::Params params{32000, "0.0.0.0", hash_server::HashServer::IP_VERSION::IPv4, hash_server::HashServer::HASH_TYPE::MD5};

constexpr char message[] = "Hello World!";


Poco::Net::StreamSocket createSocket()
{
    Poco::Net::SocketAddress sa("localhost", srv.getParams().port);
    return Poco::Net::StreamSocket(sa);
}

TEST_CASE( "Check threads" )
{
    int maxThreads = 0;
    std::vector<Poco::Net::StreamSocket> vec;
    vec.resize(std::thread::hardware_concurrency());
    for(std::size_t i = 0; i < vec.size(); ++i) {
        vec[i] = createSocket();
        vec[i].sendBytes(message, sizeof(message));
        maxThreads = maxThreads > srv.countThreads() ? maxThreads : srv.countThreads();
    }

    REQUIRE( maxThreads >= 2 );
}


int main(int argc, char* argv[]) {
    srv.setParams(params);
    srv.start();

    int result = Catch::Session().run( argc, argv );

    srv.stop();

    return result;
}
