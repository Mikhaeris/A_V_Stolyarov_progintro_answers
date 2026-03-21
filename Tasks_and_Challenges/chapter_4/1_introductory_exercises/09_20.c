#include <stdio.h>

int is_space(char c) {
    return (c == ' ' || c == '\t' || c == '\n');
}

int main(int argc, char **argv)
{
    int c;
    int prev_c = ' ';
    while ((c = getchar()) != EOF) {
        if (is_space(prev_c) && !is_space(c)) {
            putchar('(');
        }

        if (!is_space(prev_c) && is_space(c)) {
            putchar(')');
        }

        putchar(c);

        prev_c = c;
    }

    if (!(prev_c == ' ' || prev_c == '\t') && !(c == '\n' || c == EOF)) {
        putchar(')');
    }

    return 0;
}
