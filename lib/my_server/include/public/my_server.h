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

/** \class Server
 *  \brief Server main class.
 */
class DLL_PUBLIC Server {

public:
    /**
     * A default constructor.
     */
    Server();

    /**
     * A default destructor.
     */
    ~Server();

    /** \enum IP_VERSION
     * \brief Type of address type.
     */
    enum class IP_VERSION : uint8_t {
        IPv4 = 0,   /**< Internet Protocol version 4. */
        IPv6        /**< Internet Protocol version 6. */
    };

    /** \enum HASH_TYPE
     *  \brief The type of hash function used.
     */
    enum class HASH_TYPE {
        MD5 = 1,     /**< Message Digest 5. 128-bit hashing algorithm. */
        SHA1         /**< Secure Hash Algorithm 1. Cryptographic hashing algorithm. */
    };

    /** \struct Params
     *  \brief Contains parameters for starting the server.
     */
    struct Params {
        uint16_t    port{ 12345 };
        std::string address{ "0.0.0.0" };
        IP_VERSION  ipVersion{ IP_VERSION::IPv4 };
        HASH_TYPE   hashType{ HASH_TYPE::MD5 };
    };

    /** \fn setParams
     *  \brief Setting server parameters.
     *  \param[in] param struct Params
     *  \return bool
     */
    bool setParams(Params const& param);

    /** \fn getParams
     *  \brief Getting server parameters.
     *  \return struct Params
     */
    Params getParams() const noexcept;

    /** fn start
     * \brief Start server.
     * \return bool
     */
    bool start();

    /** \fn stop
     * \brief Stop server.
     */
    void stop();

    /** \fn countThreads
     * \brief Returns the current number of server threads.
     * \return count thread
     */
    int countThreads() const noexcept;

    /** \fn countThreads
     * \brief Returns the maximum number of server threads.
     * \return max threads
     */
    int maxThread() const noexcept;

private:
    class PrivateData;
    std::unique_ptr<PrivateData> m_data;

    DLL_LOCAL bool checkAddress() noexcept;
};
} // my_server
