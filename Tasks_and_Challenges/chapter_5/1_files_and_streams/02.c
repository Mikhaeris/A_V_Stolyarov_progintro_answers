#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

enum { buf_size = 4096 };
char buf[buf_size];

int main(int argc, char **argv)
{
    if (argc > 1) {
        fprintf(stderr, "usage: prog\n");
        return 1;
    }

    int count = 0;
    while ((count = read(0, buf, buf_size)) > 0) {
        int n = write(1, buf, count);
        if (n == -1) {
            perror("write");
            return 1;
        }
    }

    return 0;
}
