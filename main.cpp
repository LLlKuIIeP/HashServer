#include <iostream>
#include <my_server.h>


int main()
{
    my_server::Server srv;
    srv.start();

    while(1);

    std::cout << "Hello World!" << std::endl;
    return 0;
}
