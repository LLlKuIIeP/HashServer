#pragma once
// poco
#include <Poco/Net/TCPServerConnection.h>
#include <Poco/Net/StreamSocket.h>


namespace hash_server {

/** \class Server
 *  \brief Server main class.
 */
class /*__attribute__ ((visibility ("hidden")))*/ HashMD5: public Poco::Net::TCPServerConnection {
public:
    HashMD5(Poco::Net::StreamSocket const& streamSocket): Poco::Net::TCPServerConnection(streamSocket)
    {}

    void run();

private:
    char const m_defaultDelimeter{ '\n' };
};



} // hash_server
