#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: prog <file_name>\n");
        return 1;
    }

    int fd = open(argv[1], O_RDONLY);
    if (fd == -1) {
        perror(argv[1]);
        return 1;
    }

    off_t length = lseek(fd, 0, SEEK_END);
    printf("length %s is %lld\n", argv[1], length);
    close(fd);

    return 0;
}
