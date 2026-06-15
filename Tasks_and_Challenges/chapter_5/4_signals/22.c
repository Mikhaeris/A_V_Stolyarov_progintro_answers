#include <signal.h>
#include <stdio.h>
#include <unistd.h>

volatile sig_atomic_t ch = '+';
volatile sig_atomic_t seen = 0;

void print_ch() { write(1, (char *)&ch, 1); }

void sigalarm_handler(int s)
{
    signal(SIGALRM, sigalarm_handler);
    seen = 0;
    print_ch();
    alarm(1);
}
void sigint_handler(int s)
{
    signal(SIGINT, sigint_handler);
    if (seen) {
        _exit(0);
    }
    ch = '-';
    seen = 1;
    print_ch();
    alarm(1);
}

void sigquit_handler(int s)
{
    signal(SIGQUIT, sigquit_handler);
    ch = '+';
    print_ch();
    alarm(1);
}

int main()
{
    signal(SIGALRM, sigalarm_handler);
    signal(SIGINT, sigint_handler);
    signal(SIGQUIT, sigquit_handler);

    print_ch();
    alarm(1);

    for (;;)
        pause();

    return 0;
}
