#pragma once
// stl
#include <memory>
#include <string>

// https://www.gnu.org/software/gnulib/manual/html_node/Exported-Symbols-of-Shared-Libraries.html
// https://gcc.gnu.org/wiki/Visibility
#if defined _WIN32 || defined __CYGWIN__
  #ifdef BUILDING_DLL
    #ifdef __GNUC__
      #define DLL_PUBLIC __attribute__ ((dllexport))
    #else
      #define DLL_PUBLIC __declspec(dllexport) // Note: actually gcc seems to also supports this syntax.
    #endif
  #else
    #ifdef __GNUC__
      #define DLL_PUBLIC __attribute__ ((dllimport))
    #else
      #define DLL_PUBLIC __declspec(dllimport) // Note: actually gcc seems to also supports this syntax.
    #endif
  #endif
  #define DLL_LOCAL
#else
  #if __GNUC__ >= 4
    #define DLL_PUBLIC __attribute__ ((visibility ("default")))
    #define DLL_LOCAL  __attribute__ ((visibility ("hidden")))
  #else
    #define DLL_PUBLIC
    #define DLL_LOCAL
  #endif
#endif

namespace my_server {

class DLL_PUBLIC Server {

public:
    Server();
    ~Server();

    enum class IP_VERSION : uint8_t {
        IPv4 = 0,
        IPv6
    };

    enum class HASH_TYPE {
        MD5 = 1,
        SHA1
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

    DLL_LOCAL bool checkAddress() noexcept;
};
} // my_server
