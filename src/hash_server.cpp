// stl
#include <string>
#include <thread>
// poco
#include <Poco/Net/SocketAddress.h>
#include <Poco/Net/ServerSocket.h>
#include <Poco/Net/TCPServerParams.h>
#include <Poco/Net/TCPServer.h>
#include <Poco/Net/TCPServerConnectionFactory.h>
#include <Poco/Net/TCPServerConnection.h>
// main
#include <hash_server.h>
//private header
#include <md5_connection.h>
#include <sha1_connection.h>


namespace hash_server {
class HashServer::PrivateData {
public:
    Params params;
    std::unique_ptr<Poco::Net::TCPServer> pocoServer{ nullptr };
};

HashServer::HashServer() : m_data(std::make_unique<PrivateData>())
{}

HashServer::~HashServer() = default;

bool HashServer::setParams(Params const& param)
{
    if (!checkAddress()) {
        return false;
    }

    m_data->params = param;

    return true;
}

HashServer::Params HashServer::getParams() const noexcept
{
    return m_data->params;
}

bool HashServer::start()
{
    if (nullptr != m_data->pocoServer) {
        return false;
    }

    Poco::Net::AddressFamily::Family family = Poco::Net::AddressFamily::Family::IPv4;

    if (IP_VERSION::IPv6 == m_data->params.ipVersion) {
        family = Poco::Net::AddressFamily::Family::IPv6;
    }

    Poco::Net::SocketAddress socketAddress(family, m_data->params.address, m_data->params.port);
    Poco::Net::ServerSocket serverSocket(socketAddress);

    if (HASH_TYPE::MD5 == m_data->params.hashType) {
        m_data->pocoServer = std::make_unique<Poco::Net::TCPServer>(new Poco::Net::TCPServerConnectionFactoryImpl<HashMD5>(), serverSocket);
    }
    else if (HASH_TYPE::SHA1 == m_data->params.hashType) {
        m_data->pocoServer = std::make_unique<Poco::Net::TCPServer>(new Poco::Net::TCPServerConnectionFactoryImpl<HashSHA1>(), serverSocket);
    }
    else {
        return false;
    }

    m_data->pocoServer->start();

    return true;
}

void HashServer::stop()
{
    if (nullptr == m_data->pocoServer) {
        return;
    }

    m_data->pocoServer->stop();
}

int HashServer::countThreads() const noexcept
{
    return m_data->pocoServer->currentThreads();
}

int HashServer::maxThread() const noexcept
{
    return m_data->pocoServer->maxThreads();
}

bool HashServer::checkAddress() noexcept
{
    return true;
}


} // hash_server
