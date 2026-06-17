#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "usage: %s <prog> ...", argv[0]);
        return 1;
    }
    int fd[2];
    pipe(fd);
    pid_t pid = fork();
    if (pid == -1) {
        close(fd[0]);
        close(fd[1]);
        perror("fork");
        return 1;
    }
    if (pid == 0) {
        close(fd[0]);
        dup2(fd[1], 1);
        close(fd[1]);
        execvp(argv[1], argv + 1);
        perror("execvp");
        _exit(1);
    }
    close(fd[1]);
    enum { BEFORE_WORD, IN_WORD, AFTER_WORD } st = BEFORE_WORD;
    char ch;
    while (read(fd[0], &ch, 1) > 0) {
        if (ch == '\n') {
            write(1, &ch, 1);
            st = BEFORE_WORD;
        } else if (st == BEFORE_WORD) {
            if (ch != ' ' && ch != '\t') {
                write(1, &ch, 1);
                st = IN_WORD;
            }
        } else if (st == IN_WORD) {
            if (ch == ' ' || ch == '\t')
                st = AFTER_WORD;
            else
                write(1, &ch, 1);
        }
    }
    close(fd[0]);
    wait(NULL);
    return 0;
}
