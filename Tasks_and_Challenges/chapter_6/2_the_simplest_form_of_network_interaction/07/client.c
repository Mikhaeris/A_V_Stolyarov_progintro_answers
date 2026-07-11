#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc != 4) {
        fprintf(stderr, "usage: %s <ip> <port> <length>\n", argv[0]);
        return 1;
    }

    int ls = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (ls == -1) {
        perror("socket");
        return 1;
    }

    struct sockaddr_in addr = {0};

    addr.sin_family = AF_INET;
    addr.sin_port = htons(atoi(argv[2]));

    if (!inet_aton(argv[1], &addr.sin_addr)) {
        fprintf(stderr, "wrong ip\n");
        close(ls);
        return 1;
    }

    int size = atoi(argv[3]);
    if (size <= 0) {
        fprintf(stderr, "wrong length\n");
        close(ls);
        return 1;
    }

    char *buf = malloc(size);
    if (!buf) {
        perror("malloc");
        close(ls);
        return 1;
    }

    memset(buf, 'A', size);

    int res = sendto(ls, buf, size, 0, (struct sockaddr *)&addr, sizeof(addr));
    if (res == -1) {
        perror("sendto");
        free(buf);
        close(ls);
        return 1;
    }

    fd_set set;
    FD_ZERO(&set);
    FD_SET(ls, &set);

    struct timeval tv;
    tv.tv_sec = 15;
    tv.tv_usec = 0;

    int ready = select(ls + 1, &set, NULL, NULL, &tv);

    if (ready == -1) {
        perror("select");
    } else if (ready == 0) {
        printf("timeout\n");
    } else {
        char answer[128];

        int n = recvfrom(ls, answer, sizeof(answer) - 1, 0, NULL, NULL);

        if (n == -1) {
            perror("recvfrom");
        } else {
            answer[n] = '\0';
            printf("%s\n", answer);
        }
    }

    free(buf);
    close(ls);

    return 0;
}
