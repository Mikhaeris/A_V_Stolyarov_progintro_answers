#include <signal.h>
#include <stdio.h>
#include <unistd.h>

const char message[] = "Good bye";
static void handler(int s)
{
    write(1, message, sizeof(message) - 1);
    _exit(0);
}

int main()
{
    printf("Press Ctrl-C to quit\n");
    fflush(stdout);
    signal(SIGINT, handler);
    pause();
    return 0;
}
