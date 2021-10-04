#pragma once
// stl
#include <iostream>
#include <string>
#include <thread>
// poco
#include <Poco/Net/TCPServerConnection.h>
// hash
#include <hash_type.h>
#include <Poco/Net/StreamSocket.h>
// extern
#include <md5.h>
#include <sha1.h>


namespace my_server {

template <HASH_TYPE type>
class Hash: public Poco::Net::TCPServerConnection {
public:
    Hash(Poco::Net::StreamSocket const& streamSocket): Poco::Net::TCPServerConnection(streamSocket)
    {}

    void run()
    {
        std::string input;
        char c;
        Poco::Net::StreamSocket& streamSocket = socket();
        try {
            while (1 == streamSocket.receiveBytes(&c, 1)) {
                if (m_defaultDelimeter != c) {
                    input += c;
                }
                else {
                    input = getHash(input) + '\n';
                    socket().sendBytes(input.data(), static_cast<int>(input.size()));
                    input.clear();
                }
            }
        }
        catch (Poco::Exception& exc) {
            std::cerr << "HashConnection: " << exc.displayText() << std::endl;
        }
    }

private:
    char const m_defaultDelimeter{ '\n' };

    std::string getHash(std::string const& str)
    {
        return { "Unknown hash type." };
    }
};

template <>
std::string Hash<HASH_TYPE::MD5>::getHash(std::string const& str)
{
    return MD5()(str);
}

template <>
std::string Hash<HASH_TYPE::SHA1>::getHash(std::string const& str)
{
    return SHA1()(str);
}

} // my_server
