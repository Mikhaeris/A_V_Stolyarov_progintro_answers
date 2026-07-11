#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <unistd.h>

#define BUF_SIZE 1024

int main(int argc, char *argv[])
{
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input_fifo> <output_fifo>\n", argv[0]);
        return -1;
    }

    int in_fd = open(argv[1], O_RDWR);
    if (in_fd == -1) {
        perror("open input fifo");
        return -1;
    }

    int out_fd = open(argv[2], O_RDWR);
    if (out_fd == -1) {
        perror("open output fifo");
        close(in_fd);
        return -1;
    }

    fd_set readfds;
    char buffer[BUF_SIZE];

    while (1) {
        FD_ZERO(&readfds);
        FD_SET(STDIN_FILENO, &readfds);
        FD_SET(in_fd, &readfds);

        int maxfd = (STDIN_FILENO > in_fd ? STDIN_FILENO : in_fd);

        int ready = select(maxfd + 1, &readfds, NULL, NULL, NULL);

        if (ready == -1) {
            perror("select");
            break;
        }

        if (FD_ISSET(STDIN_FILENO, &readfds)) {
            ssize_t n = read(STDIN_FILENO, buffer, sizeof(buffer));

            if (n <= 0) {
                printf("Input closed. Exiting.\n");
                break;
            }

            write(out_fd, buffer, n);
        }

        if (FD_ISSET(in_fd, &readfds)) {
            ssize_t n = read(in_fd, buffer, sizeof(buffer));

            if (n <= 0) {
                printf("Partner has left the chat.\n");
                break;
            }

            write(STDOUT_FILENO, buffer, n);
            fflush(stdout);
        }
    }

    close(in_fd);
    close(out_fd);

    return 0;
}
