#include <stdint.h>
#include <stdio.h>

#define false 0
#define true  1

size_t get_length(const char *str)
{
    size_t length = 0;
    while (*str != '\0') {
        length++;
        str++;
    }
    return length;
}

int isalpha(char c)
{
    return (('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z'));
}

int have_repeat_characters(const char *str)
{
    uint64_t alph = 0;
    while (*str != '\0') {
        int c = *str;

        if (isalpha(c)) {
            int offset = c - ((c >= 'a') ? 'a' : 'A');
            uint64_t bit = (1ULL << offset);
            if (alph & bit) {
                return true;
            }
            alph |= bit;
        }
        str++;
    }
    return false;
}

int count_symbol(const char *str, char c)
{
    int count = 0;
    while (*str != '\0') {
        if (*str == c) {
            count++;
        }
        str++;
    }
    return count;
}

int isdigit(char c)
{
    return ('0' <= c && c <= '9');
}

int chech_condition(const char *str, int (*callback)(char))
{
    while (*str != '\0') {
        if (!(*callback)(*str)) {
            return false;
        }
        str++;
    }
    return true;
}

int have_alph(const char *str)
{
    while (*str != '\0') {
        if (isalpha(*str)) {
            return true;
        }
        str++;
    }
    return false;
}

int have_only_one_char(const char *str)
{
    int c = str[0];
    while (*str != '\0') {
        if (*str !=  c) {
            return false;
        }
        str++;
    }
    return true;
}

void process_first_str(const char *str, char arr[])
{
    while (*str != '\0') {
        arr[*str] = 1;
        str++;
    }
}

int have_common_symbol(const char *str, const char arr[])
{
    while (*str != '\0') {
        if (arr[*str]) {
            return true;
        }
        str++;
    }
    return false;
}

int main(int argc, char **argv)
{
    if (argc <= 1) {
        return 0;
    }

    char arr[128] = {0};
    char flag_print = false;

    /* a */
    size_t max_longest_length = 0;
    int max_longest_idx = 0;

    for (int i = 1; i < argc; i++) {
        char *str = argv[i];

        /* a */
        size_t cur_length = get_length(str);
        if (max_longest_length < cur_length) {
            max_longest_length = cur_length;
            max_longest_idx = i;
        }

        /* b */
        if (!have_repeat_characters(str)) {
            flag_print = true;
        }

        /* c */
        int count_commas = count_symbol(str, '@');
        int count_dots   = count_symbol(str, '.');
        if (count_commas == 1 && count_dots >= 1) {
            flag_print = true;
        }

        /* d */
        if (chech_condition(argv[0], &isdigit)) {
            flag_print = true;
        }

        /* e */
        if (have_only_one_char(str)) {
            flag_print = true;
        }

        /* f */
        if (have_alph(str)) {
            flag_print = true;
        }

        /* g */
        if (i == 0) {
            process_first_str(str, arr);
        } else if (have_common_symbol(str,arr)) {
            flag_print = true;
        }

        if (flag_print) {
            printf("%s\n", str);
        }

        flag_print = false;
    }

    /* report */
    printf("longest arg: %s length: %zu\n", argv[max_longest_idx], max_longest_length);

    return 0;
}
