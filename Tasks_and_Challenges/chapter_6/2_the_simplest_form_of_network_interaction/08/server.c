#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <port>\n", argv[0]);
        return 1;
    }

    enum { listen_queue_len = 16 };
    struct sockaddr_in addr;

    int ls = socket(AF_INET, SOCK_STREAM, 0);
    if (ls == -1) {
        perror("socket");
        return 1;
    }

    int opt = 1;
    setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

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

    res = listen(ls, listen_queue_len);
    if (res == -1) {
        perror("listen");
        close(ls);
        return 1;
    }

    for (;;) {
        socklen_t slen = sizeof(addr);

        int cls = accept(ls, (struct sockaddr *)&addr, &slen);
        if (cls < 0) {
            perror("accept");
            return 1;
        }

        time_t now = time(NULL);
        struct tm tm_info;
        localtime_r(&now, &tm_info);

        char datetime[32];
        strftime(datetime, sizeof(datetime), "%Y-%m-%d %H:%M:%S", &tm_info);

        char ip[INET_ADDRSTRLEN];
        inet_ntop(AF_INET, &addr.sin_addr, ip, sizeof(ip));

        uint16_t port = ntohs(addr.sin_port);

        char answer[128];
        int ans_len = snprintf(answer, sizeof(answer), "%s %s %u\n", datetime, ip, port);

        write(cls, answer, ans_len);

        close(cls);
    }

    return 0;
}
