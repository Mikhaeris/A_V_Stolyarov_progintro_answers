#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (argc < 3) {
        fprintf(stderr,
                "usage: %s <file_name> <program_name> <args> ...\n",
                argv[0]);
        return 1;
    }

    int fd = open(argv[1], O_WRONLY | O_APPEND);
    if (fd == -1) {
        perror(argv[1]);
        exit(1);
    }

    pid_t pid = fork();
    if (pid == -1) {
        perror("fork");
        exit(1);
    }
    if (pid == 0) {
        dup2(fd, 1);
        close(fd);
        execvp(argv[2], argv + 2);
        perror(argv[2]);
        _exit(1);
    }

    close(fd);
    wait(NULL);
    return 0;
}
