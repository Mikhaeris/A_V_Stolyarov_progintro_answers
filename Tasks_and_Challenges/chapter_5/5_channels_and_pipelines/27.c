#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "usage: %s <prog> [args...]\n", argv[0]);
        return 1;
    }

    int fd[2];
    if (pipe(fd) == -1) {
        perror("pipe");
        return 1;
    }

    pid_t pid = fork();
    if (pid == -1) {
        perror("fork");
        return 1;
    }

    if (pid == 0) {
        close(fd[1]);
        dup2(fd[0], 0);
        close(fd[0]);
        execvp(argv[1], argv + 1);
        perror("execvp");
        _exit(127);
    }

    close(fd[0]);

    signal(SIGPIPE, SIG_IGN);

    char buf[16];
    for (int i = 1; i <= 1000000; i++) {
        int n = sprintf(buf, "%d\n", i);
        int off = 0, stop = 0;
        while (off < n) {
            ssize_t w = write(fd[1], buf + off, n - off);
            if (w == -1) {
                if (errno == EINTR)
                    continue;
                if (errno == EPIPE)
                    stop = 1;
                else
                    perror("write"), stop = 1;
                break;
            }
            off += w;
        }
        if (stop)
            break;
    }
    close(fd[1]);

    int status;
    if (wait(&status) == -1) {
        perror("wait");
        return 1;
    }

    if (WIFEXITED(status))
        printf("external program exited on its own, return code %d\n",
               WEXITSTATUS(status));
    else if (WIFSIGNALED(status))
        printf("external program terminated by signal %d\n", WTERMSIG(status));
    else
        printf("external program terminated in an unusual way\n");

    return 0;
}
