#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

enum { bufsize = 256 };

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: %s <file_name>\n", argv[0]);
        return 1;
    }
    if (!isatty(0)) {
        fprintf(stderr,
                "stdin is not a terminal, refusing to read a password\n");
        return 1;
    }

    int fd = open(argv[1], O_RDONLY);
    if (fd == -1) {
        fprintf(stderr, "can't open file %s\n", argv[1]);
        return 1;
    }
    char filebuf[bufsize];
    ssize_t fn = read(fd, filebuf, sizeof(filebuf) - 1);
    close(fd);
    if (fn < 0) {
        perror("read");
        return 1;
    }
    filebuf[fn] = '\0';
    filebuf[strcspn(filebuf, "\n")] = '\0';

    struct termios saved, quiet;
    if (tcgetattr(0, &saved) == -1) {
        perror("tcgetattr");
        return 1;
    }
    quiet = saved;
    quiet.c_lflag &= ~ECHO;
    if (tcsetattr(0, TCSAFLUSH, &quiet) == -1) {
        perror("tcsetattr");
        return 1;
    }

    char input[bufsize];
    fputs("password: ", stderr);
    char *p = fgets(input, sizeof(input), stdin);

    tcsetattr(0, TCSAFLUSH, &saved);
    fputc('\n', stderr);

    if (!p) {
        fprintf(stderr, "no password entered\n");
        return 1;
    }
    input[strcspn(input, "\n")] = '\0';

    if (strcmp(input, filebuf) != 0) {
        fprintf(stderr, "incorrect password\n");
        return 1;
    }
    return 0;
}
