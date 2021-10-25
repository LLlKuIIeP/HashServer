// stl
#include <iostream>
// extern
#include <sha1.h>
// main
#include <sha1_connection.h>


namespace hash_server {

void HashSHA1::run()
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
                input = SHA1()(input) + '\n';
                socket().sendBytes(input.data(), static_cast<int>(input.size()));
                input.clear();
            }
        }
    }
    catch (Poco::Exception& exc) {
        std::cerr << "HashConnection: " << exc.displayText() << std::endl;
    }
}

} // hash_server
