#include <stdint.h>
#include <stdio.h>

#define false 0
#define true  1

int my_isdigit(char c)
{
    return ('0' <= c && c <= '9');
}

int64_t my_atoi(const char *str)
{
    int64_t num = 0;
    while (*str != '\0') {
        char c = *str;
        if (!my_isdigit(c)) {
            return num;
        }
        num *= 10;
        num += c - '0';
        str++;
    }

    return num;
}

uint64_t reverse_num(uint64_t num)
{
    uint64_t ans = 0;
    while (num != 0) {
        ans *= 10;
        ans += num % 10;
        num /= 10;
    }
    return ans;
}

int main(int argc, char **argv)
{
    if (argc != 3) {
        fprintf(stderr, "Error: need two arg: <N> - start, <M> - end!\n");
        return 1;
    }

    int64_t n = my_atoi(argv[1]);
    int64_t m = my_atoi(argv[2]);

    if (n > m) {
        fprintf(stderr,"Error: N must be <= M!\n");
        return 1;
    }

    uint64_t length = 0;
    for (uint64_t i = 1; true; i++) {
        uint64_t square_num = i * i;
        uint64_t rev_num = reverse_num(square_num);
        while (rev_num != 0) {
            length++;
            if (n <= length && length <= m) {
                printf("%lu", rev_num % 10);
            }
            rev_num /= 10;
        }

        if (length >= m) {
            break;
        }
    }
    puts("\n");

    return 0;
}
