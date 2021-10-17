#pragma once
// stl
#include <memory>
#include <string>


namespace my_server {
#if defined(WIN32) || defined(_WIN32)
class __declspec( dllexport ) Server {
#elif __linux__
class Server {
#endif

public:
    Server();
    ~Server();

    enum class IP_VERSION : uint8_t {
        IPv4 = 0,
        IPv6
    };

    enum class HASH_TYPE {
        MD5 = 1,
        SHA1,
        SHA3,
        SHA256
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
