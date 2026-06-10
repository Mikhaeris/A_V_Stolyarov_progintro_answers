#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc != 4) {
        fprintf(stderr, "usage: prog <file_1> <file_2> <file_3>\n");
        return 1;
    }

    FILE *f1 = fopen(argv[1], "r");
    if (!f1) {
        fprintf(stderr, "File %s opening failed\n", argv[1]);
        return 1;
    }
    FILE *f2 = fopen(argv[2], "w");
    if (!f2) {
        fclose(f1);
        fprintf(stderr, "File %s opening failed\n", argv[2]);
        return 1;
    }
    int f3_fd = open(argv[3], O_WRONLY | O_CREAT | O_TRUNC, 0666);
    if (f3_fd == -1) {
        fclose(f1);
        fclose(f2);
        fprintf(stderr, "File %s opening failed\n", argv[3]);
        return 1;
    }

    int status = 0;
    int c;
    int len = 0;
    int flag = 0;
    int at_start = 1;
    while ((c = fgetc(f1)) != EOF) {
        if (at_start) {
            flag = (c == ' ');
            at_start = 0;
        }
        if (flag) {
            int code = fputc(c, f2);
            if (code == EOF) {
                fprintf(stderr, "Bad write!\n");
                status = 1;
                goto out;
            }
        }
        if (c == '\n') {
            int code = write(f3_fd, &len, sizeof(len));
            if (code != sizeof(len)) {
                fprintf(stderr, "Bad write!\n");
                status = 1;
                goto out;
            }
            len = 0;
            at_start = 1;
        } else {
            len += 1;
        }
    }
    if (!at_start) {
        int code = write(f3_fd, &len, sizeof(len));
        if (code != sizeof(len)) {
            fprintf(stderr, "Bad write!\n");
            status = 1;
            goto out;
        }
    }

out:
    fclose(f1);
    fclose(f2);
    close(f3_fd);
    return status;
}
