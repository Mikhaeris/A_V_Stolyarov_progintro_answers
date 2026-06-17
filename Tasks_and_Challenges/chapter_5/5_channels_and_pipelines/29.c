#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

static int write_all(int fd, const char *buf, size_t n)
{
    size_t off = 0;
    while (off < n) {
        ssize_t w = write(fd, buf + off, n - off);
        if (w == -1) {
            if (errno == EINTR) continue;
            return -1;
        }
        off += (size_t)w;
    }
    return 0;
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "usage: %s <prog> [args...]\n", argv[0]);
        return 1;
    }

    int in_pipe[2];
    int out_pipe[2];
    if (pipe(in_pipe) == -1 || pipe(out_pipe) == -1) { perror("pipe"); return 1; }

    pid_t prog = fork();
    if (prog == -1) { perror("fork"); return 1; }
    if (prog == 0) {
        dup2(in_pipe[0], 0);
        dup2(out_pipe[1], 1);
        close(in_pipe[0]);  close(in_pipe[1]);
        close(out_pipe[0]); close(out_pipe[1]);
        execvp(argv[1], argv + 1);
        perror("execvp");
        _exit(127);
    }

    pid_t feeder = fork();
    if (feeder == -1) { perror("fork"); return 1; }
    if (feeder == 0) {
        close(in_pipe[0]);
        close(out_pipe[0]); close(out_pipe[1]);
        signal(SIGPIPE, SIG_IGN);
        char buf[16];
        for (int i = 1; i <= 1000000; i++) {
            int n = sprintf(buf, "%d\n", i);
            if (write_all(in_pipe[1], buf, (size_t)n) == -1) break;
        }
        close(in_pipe[1]);
        _exit(0);
    }

    close(in_pipe[0]); close(in_pipe[1]);
    close(out_pipe[1]);

    size_t count_chars = 0, count_lines = 0;
    char buffer[4096];
    ssize_t rd;
    while ((rd = read(out_pipe[0], buffer, sizeof buffer)) > 0) {
        count_chars += (size_t)rd;
        for (ssize_t i = 0; i < rd; i++)
            if (buffer[i] == '\n') count_lines++;
    }
    close(out_pipe[0]);

    int status, prog_exit = -1, prog_signal = -1;
    pid_t w;
    while ((w = wait(&status)) != -1) {
        if (w == prog) {
            if (WIFEXITED(status)) prog_exit = WEXITSTATUS(status);
            else if (WIFSIGNALED(status)) prog_signal = WTERMSIG(status);
        }
    }

    if (prog_signal != -1)
        printf("external program terminated by signal %d\n", prog_signal);
    else if (prog_exit != -1)
        printf("external program exited on its own, return code %d\n", prog_exit);
    else
        printf("external program terminated in an unusual way\n");
    printf("count chars: %zu\n", count_chars);
    printf("count lines: %zu\n", count_lines);
    return 0;
}
