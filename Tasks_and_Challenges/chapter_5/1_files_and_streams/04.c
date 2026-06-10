#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

enum { buf_size = 4096 };

char buf[buf_size];

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: prog <file_name>\n");
        return 1;
    }
    int status = 0;

    int fd = open(argv[1], O_RDONLY);
    if (fd == -1) {
        fprintf(stderr, "File %s opening failed\n", argv[1]);
        return 1;
    }

    int count_lines = 0;
    int length = 0;
    while ((length = read(fd, buf, buf_size)) > 0) {
        for (int i = 0; i < buf_size; i++) {
            if (buf[i] == '\n') {
                count_lines += 1;
            }
        }
    }
    if (length < 0) {
        fprintf(stderr, "bad read\n");
        status = 1;
        goto out;
    }

    printf("count lines: %d\n", count_lines);

out:
    close(fd);
    return status;
}
