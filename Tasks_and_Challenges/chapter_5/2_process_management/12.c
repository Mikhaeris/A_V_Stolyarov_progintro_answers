#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "usage: %s <prog_name> ...\n", argv[0]);
        return 1;
    }

    int pid = fork();
    if (pid == -1) {
        perror("fork");
        exit(1);
    }
    if (pid == 0) {
        execvp(argv[1], argv + 1);
        exit(1);
    }

    int status;
    wait(&status);
    if (WIFEXITED(status)) {
        printf("exited %d\n", WEXITSTATUS(status));
    } else if (WIFSIGNALED(status)) {
        printf("killed %d\n", WTERMSIG(status));
    }

    return 0;
}
