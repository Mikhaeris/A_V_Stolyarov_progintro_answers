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

    int fd[2];
    pipe(fd);
    pid_t pid2 = fork();
    if (pid2 == -1) {
        perror("fork");
        return 1;
    }
    if (pid2 == 0) {
        close(fd[1]);
        dup2(fd[0], 0);
        close(fd[0]);
        execvp(argv[second], argv + second);
        _exit(1);
    }
    pid_t pid1 = fork();
    if (pid1 == -1) {
        perror("fork");
        return 1;
    }
    if (pid1 == 0) {
        close(fd[0]);
        dup2(fd[1], 1);
        close(fd[1]);
        execvp(argv[1], argv + 1);
        exit(1);
    }

    close(fd[0]);
    close(fd[1]);

    for (int i = 0; i < 2; i++) {
        wait(NULL);
    }

    return 0;
}
