#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc != 4) {
        fprintf(stderr, "usage: %s <ip> <port> <some_string>\n", argv[0]);
        return 1;
    }

    int ls = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (ls == -1) {
        perror("socket");
        return 1;
    }

    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    int port = atoi(argv[2]);
    if (port <= 0 || port > 65535) {
        fprintf(stderr, "error: wrong port\n");
        close(ls);
        return 1;
    }
    addr.sin_port = htons(port);
    int ok = inet_aton(argv[1], &(addr.sin_addr));
    if (!ok) {
        fprintf(stderr, "error: wrong ip\n");
        close(ls);
        return 1;
    }

    int n = sendto(ls,
           argv[3],
           strlen(argv[3]),
           0,
           (struct sockaddr *)&addr,
           sizeof(addr));

    if (n == -1) {
        perror("sendto");
        close(ls);
        return 1;
    }

    close(ls);
    return 0;
}
