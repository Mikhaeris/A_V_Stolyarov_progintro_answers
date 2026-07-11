#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
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

    int opt = 1;
    setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    int port = atoi(argv[1]);
    if (port <= 0 || port > 65535) {
        fprintf(stderr, "error: wrong port\n");
        close(ls);
        return 1;
    }
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = htonl(INADDR_ANY);

    int res = bind(ls, (struct sockaddr *)&addr, sizeof(addr));
    if (res == -1) {
        perror("bind");
        close(ls);
        return 1;
    }

    enum { buf_size = 1024 };
    char buf[buf_size];
    struct sockaddr_in addr_g;
    while (1) {
        socklen_t len = sizeof(addr_g);
        int n =
            recvfrom(ls, buf, buf_size, 0, (struct sockaddr *)&addr_g, &len);

        if (n == -1) {
            perror("recvfrom");
            continue;
        }

        printf(
            "from %s:%d\n", inet_ntoa(addr_g.sin_addr), ntohs(addr_g.sin_port));

        for (int i = 0; i < n; i++) {
            unsigned char c = buf[i];

            if ((c >= 32 && c <= 126) || c == '\n' || c == '\t') {
                putchar(c);
            } else {
                putchar('?');
            }
        }

        printf("\n");
    }

    close(ls);

    return 0;
}
