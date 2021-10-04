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
#include <my_server.h>
//private header
#include <hash_connection.h>

namespace my_server {
class Server::PrivateData {
public:
    Params params;
    std::unique_ptr<Poco::Net::TCPServer> pocoServer{ nullptr };
};

Server::Server() : m_data(std::make_unique<PrivateData>())
{}

Server::~Server() = default;

bool Server::setParams(Params const& param)
{
    if (!checkAddress()) {
        return false;
    }

    m_data->params = param;

    return true;
}

Server::Params Server::getParams() const noexcept
{
    return m_data->params;
}

bool Server::start()
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
        m_data->pocoServer = std::make_unique<Poco::Net::TCPServer>(new Poco::Net::TCPServerConnectionFactoryImpl<Hash<HASH_TYPE::MD5>>(), serverSocket);
    }
    else if (HASH_TYPE::SHA1 == m_data->params.hashType) {
        m_data->pocoServer = std::make_unique<Poco::Net::TCPServer>(new Poco::Net::TCPServerConnectionFactoryImpl<Hash<HASH_TYPE::SHA1>>(), serverSocket);
    }
    else {
        return false;
    }

    m_data->pocoServer->start();

    return true;
}

void Server::stop()
{
    m_data->pocoServer->stop();
}

int Server::countThreads() const noexcept
{
    return m_data->pocoServer->currentThreads();
}

int Server::maxThread() const noexcept
{
    return m_data->pocoServer->maxThreads();
}

bool Server::checkAddress() noexcept
{
    return true;
}


} // my_server
