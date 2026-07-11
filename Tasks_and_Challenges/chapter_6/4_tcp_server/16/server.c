#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc != 3) {
        fprintf(stderr, "usage: %s <port> <html_file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[2], "rb");
    if (file == NULL) {
        perror("fopen");
        return 1;
    }

    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    rewind(file);

    int ls = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (ls == -1) {
        perror("socket");
        fclose(file);
        return 1;
    }

    int opt = 1;
    setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    struct sockaddr_in addr = {0};
    addr.sin_family = AF_INET;
    addr.sin_port = htons(atoi(argv[1]));
    addr.sin_addr.s_addr = htonl(INADDR_ANY);

    int res = bind(ls, (struct sockaddr *)&addr, sizeof(addr));
    if (res == -1) {
        perror("bind");
        fclose(file);
        close(ls);
        return 1;
    }

    res = listen(ls, SOMAXCONN);
    if (res == -1) {
        perror("listen");
        fclose(file);
        close(ls);
        return 1;
    }

    while (1) {
        int cs = accept(ls, NULL, NULL);
        if (cs == -1) {
            perror("accept");
            continue;
        }

        char request[4096];
        recv(cs, request, sizeof(request), 0);

        rewind(file);

        char header[256];
        int header_len = snprintf(header,
                                  sizeof(header),
                                  "HTTP/1.1 200 OK\r\n"
                                  "Content-Type: text/html\r\n"
                                  "Content-Length: %ld\r\n"
                                  "Connection: close\r\n"
                                  "\r\n",
                                  file_size);

        send(cs, header, header_len, 0);

        char buffer[4096];

        while (1) {
            int n = fread(buffer, 1, sizeof(buffer), file);
            if (n == 0)
                break;

            send(cs, buffer, n, 0);
        }

        close(cs);
    }

    fclose(file);
    close(ls);

    return 0;
}
