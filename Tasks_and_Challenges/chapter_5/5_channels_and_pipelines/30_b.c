#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    int second = 0;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], ";;") == 0) {
            second = i + 1;
            argv[i] = NULL;
            break;
        }
    }
    if (second == 0 || second >= argc) {
        fprintf(stderr, "usage: %s <prog_1> ... ;; <prog_2> ...\n", argv[0]);
        return 1;
    }

    int fd1[2];
    int fd2[2];
    if (pipe(fd1) == -1 || pipe(fd2) == -1) {
        perror("pipe");
        return 1;
    }

    pid_t pid2 = fork();
    if (pid2 == -1) {
        perror("fork");
        return 1;
    }
    if (pid2 == 0) {
        close(fd1[0]);
        close(fd1[1]);
        close(fd2[1]);
        dup2(fd2[0], 0);
        close(fd2[0]);
        execvp(argv[second], argv + second);
        _exit(1);
    }

    pid_t pid1 = fork();
    if (pid1 == -1) {
        perror("fork");
        return 1;
    }
    if (pid1 == 0) {
        close(fd2[0]);
        close(fd2[1]);
        close(fd1[0]);
        dup2(fd1[1], 1);
        close(fd1[1]);
        execvp(argv[1], argv + 1);
        _exit(1);
    }

    close(fd1[1]);
    close(fd2[0]);

    FILE *in = fdopen(fd1[0], "r");
    FILE *out = fdopen(fd2[1], "w");

    char *line = NULL;
    size_t cap = 0;
    ssize_t n;
    while ((n = getline(&line, &cap, in)) != -1) {
        if (n > 0 && (line[0] == ' ' || line[0] == '\t')) {
            fwrite(line, 1, (size_t)n, out);
        }
    }
    free(line);

    fclose(out);
    fclose(in);

    for (int i = 0; i < 2; i++) {
        wait(NULL);
    }
    return 0;
}
