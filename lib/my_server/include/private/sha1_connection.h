#pragma once
// poco
#include <Poco/Net/TCPServerConnection.h>
#include <Poco/Net/StreamSocket.h>


namespace my_server {


class /*__attribute__ ((visibility ("hidden")))*/ HashSHA1: public Poco::Net::TCPServerConnection {
public:
    HashSHA1(Poco::Net::StreamSocket const& streamSocket): Poco::Net::TCPServerConnection(streamSocket)
    {}

    void run();

private:
    char const m_defaultDelimeter{ '\n' };
};



} // my_server
