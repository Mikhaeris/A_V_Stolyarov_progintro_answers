#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: %s <port>\n", argv[0]);
        return 1;
    }

    int ls = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (ls == -1) {
        perror("socket");
        return 1;
    }

    struct sockaddr_in addr = {0};
    addr.sin_family = AF_INET;
    addr.sin_port = htons(atoi(argv[1]));
    addr.sin_addr.s_addr = htonl(INADDR_ANY);

    int res = bind(ls, (struct sockaddr *)&addr, sizeof(addr));
    if (res == -1) {
        perror("bind");
        close(ls);
        return 1;
    }

    enum { BUF_SIZE = 65536 };

    char buf[BUF_SIZE];

    unsigned long datagrams = 0;
    unsigned long bytes = 0;

    while (1) {
        struct sockaddr_in client;
        socklen_t len = sizeof(client);

        int n = recvfrom(ls, buf, sizeof(buf), 0, (struct sockaddr *)&client, &len);
        if (n == -1) {
            perror("recvfrom");
            continue;
        }

        datagrams++;
        bytes += n;

        char answer[128];

        int ans_len = snprintf(answer, sizeof(answer), "%lu %lu", datagrams, bytes);

        sendto(ls, answer, ans_len, 0, (struct sockaddr *)&client, len);
    }

    close(ls);

    return 0;
}
