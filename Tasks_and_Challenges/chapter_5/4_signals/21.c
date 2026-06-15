#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

volatile sig_atomic_t cnt = 0;

static void sigint_handler(int s)
{
    signal(SIGINT, sigint_handler);
    cnt += 1;
}

static void sigusr1_handler(int s)
{
    signal(SIGUSR1, sigusr1_handler);
    char buf[32];
    int len = 0;

    sig_atomic_t x = cnt;

    if (x == 0) {
        buf[len++] = '0';
    } else {
        char tmp[32];
        int p = 0;

        while (x > 0) {
            tmp[p++] = '0' + x % 10;
            x /= 10;
        }

        while (p > 0)
            buf[len++] = tmp[--p];
    }

    buf[len++] = '\n';

    write(STDOUT_FILENO, buf, len);
}

int main()
{
    signal(SIGINT, sigint_handler);
    signal(SIGUSR1, sigusr1_handler);
    for (;;) {
        pause();
    }
    return 0;
}
