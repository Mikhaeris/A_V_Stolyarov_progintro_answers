#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main()
{
    int fd[2];
    pipe(fd);
    pid_t pid = fork();
    if (pid == 0) {
        close(fd[0]);
        char buf[] = "Text";
        write(fd[1], buf, sizeof(buf) - 1);
        exit(0);
    }
    close(fd[1]);

    ssize_t rc;
    char buf[1024];
    while ((rc = read(fd[0], buf, sizeof(buf))) > 0) {
        write(1, buf, rc);
    }

    wait(NULL);
    close(fd[0]);
    return 0;
}
