#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

volatile sig_atomic_t count_chars = 0;
volatile sig_atomic_t count_lines = 0;
volatile sig_atomic_t ctrlc_seen = 0;

char buf[] = "You sleep?\n";

void sigalarm_handler(int s)
{
    signal(SIGALRM, sigalarm_handler);
    ctrlc_seen = 0;
    write(1, buf, strlen(buf));
    alarm(5);
}

void print_num(int val)
{
    char buf[16];
    if (val == 0) {
        write(1, "0", 1);
        return;
    }

    int i = sizeof(buf) - 1;
    while (val > 0 && i >= 0) {
        buf[i--] = '0' + (val % 10);
        val /= 10;
    }
    write(1, buf + i + 1, sizeof(buf) - 2 - i);
}

void sigint_handler(int s)
{
    signal(SIGINT, sigint_handler);

    if (ctrlc_seen) {
        _exit(0);
    }

    ctrlc_seen = 1;

    char lf = '\n';

    write(1, "Chars: ", 7);
    print_num(count_chars);
    write(1, &lf, 1);

    write(1, "Lines: ", 7);
    print_num(count_lines);
    write(1, &lf, 1);

    alarm(5);
}

int main()
{
    signal(SIGALRM, sigalarm_handler);
    signal(SIGINT, sigint_handler);

    alarm(5);
    ssize_t res;

    char ch;

    while (1) {
        res = read(0, &ch, 1);

        if (res > 0) {
            ctrlc_seen = 0;

            if (ch == '\n') {
                count_lines += 1;
            } else {
                count_chars += 1;
            }
            alarm(5);

        } else if (res == 0) {
            break;

        } else if (res < 0) {
            if (errno == EINTR)
                continue;
            break;
        }
    }

    return 0;
}
