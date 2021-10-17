// stl
#include <iostream>
#include <string>
#include <thread>
// extern
#include <md5.h>
// main
#include <md5_connection.h>


namespace my_server {

void HashMD5::run()
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
                input = MD5()(input) + '\n';
                socket().sendBytes(input.data(), static_cast<int>(input.size()));
                input.clear();
            }
        }
    }
    catch (Poco::Exception& exc) {
        std::cerr << "HashConnection: " << exc.displayText() << std::endl;
    }
}

} // my_server
