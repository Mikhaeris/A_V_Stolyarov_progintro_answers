#include <limits.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc < 3) {
        fprintf(stderr, "usage: prog <file_dat_1> <file_dat_...> <file_out>\n");
        return 1;
    }

    int status = 0;

    FILE *fout = fopen(argv[argc-1], "w");
    if (!fout) {
        fprintf(stderr, "File %s opening failed\n", argv[argc-1]);
        return 1;
    }

    for (int i = 1; i < argc-1; i++) {
        int fd = open(argv[i], O_RDONLY);
        if (fd == -1) {
            fprintf(stderr, "File %s opening failed\n", argv[i]);
            status = 1;
            continue;
        }

        int min_n = INT_MAX;
        int max_n = INT_MIN;
        int count_n = 0;

        int num;
        int r = 0;
        while ((r = read(fd, &num, sizeof(num))) == sizeof(num)) {
            if (min_n > num) {
                min_n = num;
            }

            if (max_n < num) {
                max_n = num;
            }

            count_n += 1;
        }
        close(fd);
        if (r == -1) {
            fprintf(stderr, "Bad read from file %s!\n", argv[i]);
            status = 1;
            goto out;
        }

        int code = 0;
        if (count_n == 0) {
            fprintf(fout, "%s %d\n", argv[i], count_n);
        } else {
            fprintf(fout, "%s %d %d %d\n", argv[i], count_n, min_n, max_n);
        }

        if (code < 0) {
            fprintf(stderr, "Bad write!\n");
            status = 1;
            goto out;
        }
    }

out:
    fclose(fout);
    return status;
}
