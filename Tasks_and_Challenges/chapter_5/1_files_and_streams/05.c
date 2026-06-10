#include <fcntl.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

enum { buf_size = 4096 };

int main(int argc, char **argv)
{
    if (argc != 5) {
        fprintf(stderr,
                "usage: <file_name> <start_position> <length> <byte>\n");
        return 1;
    }
    int status = 0;

    int fd = open(argv[1], O_RDWR);
    if (fd == -1) {
        fprintf(stderr, "File %s opening failed\n", argv[1]);
        return 1;
    }
    off_t file_size = lseek(fd, 0, SEEK_END);

    int start_position = atoi(argv[2]);
    if (start_position < 0 || start_position > file_size) {
        fprintf(stderr, "start_position out of range");
        status = 1;
        goto out;
    }

    int length = atoi(argv[3]);
    if (length < 0) {
        fprintf(stderr, "negative length\n");
        status = 1;
        goto out;
    }

    int byte = argv[4][0];

    char buf[buf_size];
    memset(buf, byte, sizeof(buf));

    lseek(fd, start_position, SEEK_SET);

    long remaining = length;
    while (remaining > 0) {
        size_t chunk = remaining > buf_size ? buf_size : remaining;
        ssize_t w = write(fd, buf, chunk);
        if (w < 0) {
            fprintf(stderr, "bad write\n");
            status = 1;
            goto out;
        }
        remaining -= w;
    }

out:
    close(fd);
    return status;
}
