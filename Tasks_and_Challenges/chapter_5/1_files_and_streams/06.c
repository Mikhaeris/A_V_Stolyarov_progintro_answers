#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

enum { buf_size = 4096 };

int main(int argc, char **argv)
{
    if (argc != 3) {
        fprintf(stderr, "usage: %s <file_name> <key>\n", argv[0]);
        return 1;
    }

    errno = 0;
    char *end;
    unsigned long k = strtoul(argv[2], &end, 0);
    if (end == argv[2] || *end != '\0' || errno != 0 || k > 0xFFFFFFFFUL) {
        fprintf(stderr, "bad key (expected 0..4294967295): %s\n", argv[2]);
        return 1;
    }
    uint32_t key = (uint32_t) k;
    unsigned char kb[4] = {
        (unsigned char)(key        & 0xFF),
        (unsigned char)((key >> 8)  & 0xFF),
        (unsigned char)((key >> 16) & 0xFF),
        (unsigned char)((key >> 24) & 0xFF),
    };

    int fd = open(argv[1], O_RDWR);
    if (fd == -1) {
        fprintf(stderr, "can't open file %s\n", argv[1]);
        return 1;
    }

    int status = 0;
    unsigned char buf[buf_size];
    long long pos = 0;
    ssize_t count;

    while ((count = read(fd, buf, sizeof(buf))) > 0) {
        for (ssize_t i = 0; i < count; i++) {
            buf[i] ^= kb[(pos + i) & 3];
        }
        if (lseek(fd, -count, SEEK_CUR) == (off_t) -1) {
            fprintf(stderr, "lseek failed\n");
            status = 1;
            goto out;
        }
        ssize_t off = 0;
        while (off < count) {
            ssize_t w = write(fd, buf + off, count - off);
            if (w < 0) {
                fprintf(stderr, "write failed\n");
                status = 1;
                goto out;
            }
            off += w;
        }
        pos += count;
    }
    if (count < 0) {
        fprintf(stderr, "read failed\n");
        status = 1;
    }
out:
    close(fd);
    return status;
}
