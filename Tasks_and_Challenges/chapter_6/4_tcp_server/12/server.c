#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <unistd.h>

#define BUF_SIZE 4096

typedef struct {
    int used;
    int fd;
    char buffer[BUF_SIZE];
    int len;
} Client;

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <port>\n", argv[0]);
        return -1;
    }

    int ls = socket(AF_INET, SOCK_STREAM, 0);
    if (ls == -1) {
        perror("socket");
        return -1;
    }

    int opt = 1;
    setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);

    int port = atoi(argv[1]);
    if (port <= 0 || port > 65535) {
        fprintf(stderr, "Wrong port\n");
        close(ls);
        return -1;
    }

    addr.sin_port = htons(port);

    int res = bind(ls, (struct sockaddr *)&addr, sizeof(addr));
    if (res == -1) {
        perror("bind");
        close(ls);
        return -1;
    }

    res = listen(ls, 16);
    if (res == -1) {
        perror("listen");
        close(ls);
        return -1;
    }

    Client clients[FD_SETSIZE];
    memset(clients, 0, sizeof(clients));

    for (;;) {
        fd_set readfds;
        FD_ZERO(&readfds);

        FD_SET(ls, &readfds);

        int maxfd = ls;

        for (int i = 0; i < FD_SETSIZE; i++) {
            if (clients[i].used) {
                FD_SET(clients[i].fd, &readfds);
                if (clients[i].fd > maxfd)
                    maxfd = clients[i].fd;
            }
        }

        int ready = select(maxfd + 1, &readfds, NULL, NULL, NULL);

        if (ready == -1) {
            if (errno == EINTR)
                continue;

            perror("select");
            break;
        }

        if (FD_ISSET(ls, &readfds)) {
            int fd = accept(ls, NULL, NULL);

            if (fd != -1) {
                int placed = 0;
                for (int i = 0; i < FD_SETSIZE; i++) {
                    if (!clients[i].used) {

                        clients[i].used = 1;
                        clients[i].fd = fd;
                        clients[i].len = 0;

                        placed = 1;
                        break;
                    }
                }

                if (!placed) {
                    fprintf(stderr, "Too many clients\n");
                    close(fd);
                }
            }
        }

        for (int i = 0; i < FD_SETSIZE; i++) {
            if (!clients[i].used)
                continue;

            int fd = clients[i].fd;
            if (!FD_ISSET(fd, &readfds))
                continue;

            ssize_t n = recv(fd, clients[i].buffer + clients[i].len, BUF_SIZE - clients[i].len, 0);

            if (n <= 0) {
                close(fd);
                clients[i].used = 0;
                continue;
            }

            clients[i].len += n;

            int start = 0;
            for (int j = 0; j < clients[i].len; j++) {
                if (clients[i].buffer[j] == '\n') {
                    send(fd, "Ok\n", 3, 0);
                    start = j + 1;
                }
            }

            if (start > 0) {
                memmove(clients[i].buffer, clients[i].buffer + start, clients[i].len - start);
                clients[i].len -= start;
            }

            if (clients[i].len == BUF_SIZE)
                clients[i].len = 0;
        }
    }

    close(ls);

    return 0;
}
