#include <iostream>
#include <hash_server.h>


int main()
{
    hash_server::HashServer srv;
    srv.start();

    while(1);

    std::cout << "Hello World!" << std::endl;
    return 0;
}
