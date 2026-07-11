#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <unistd.h>

#define BUF_SIZE 256

int main()
{
    char name[BUF_SIZE];

    printf("What is your name, please? ");
    fflush(stdout);

    fd_set readfds;
    FD_ZERO(&readfds);
    FD_SET(STDIN_FILENO, &readfds);

    struct timeval timeout;
    timeout.tv_sec = 15;
    timeout.tv_usec = 0;

    int result = select(STDIN_FILENO + 1, &readfds, NULL, NULL, &timeout);
    if (result == -1) {
        perror("select");
        return -1;
    }
    if (result == 0) {
        printf("\nSorry, I'm terribly busy.\n");
        return -1;
    }
    if (fgets(name, sizeof(name), stdin) == NULL) {
        fprintf(stderr, "Input error.\n");
        return -1;
    }

    name[strcspn(name, "\n")] = '\0';

    printf("Nice to meet you, dear %s!\n", name);

    return 0;
}
