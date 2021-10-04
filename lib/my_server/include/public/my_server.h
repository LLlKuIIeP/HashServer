#pragma once
// stl
#include <memory>
#include <string>
// hash
#include <hash_type.h>


namespace my_server {

class Server {
public:
    Server();
    ~Server();

    enum class IP_VERSION : uint8_t {
        IPv4 = 0,
        IPv6
    };

    struct Params {
        uint16_t    port{ 12345 };
        std::string address{ "0.0.0.0" };
        IP_VERSION  ipVersion{ IP_VERSION::IPv4 };
        HASH_TYPE   hashType{ HASH_TYPE::MD5 };
    };

    bool setParams(Params const& param);
    Params getParams() const noexcept;

    bool start();
    void stop();

    int countThreads() const noexcept;
    int maxThread() const noexcept;

private:
    class PrivateData;
    std::unique_ptr<PrivateData> m_data;

    bool checkAddress() noexcept;
};
} // my_server
