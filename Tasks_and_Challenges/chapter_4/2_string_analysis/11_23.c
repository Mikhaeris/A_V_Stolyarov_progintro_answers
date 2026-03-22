#include <stdio.h>

int is_space(char c)
{
    return (c == ' ' || c == '\t');
}

int main(int argc, char **argv)
{
    if (argc > 2) {
        printf("Error: too many args, need one arg!");
    }

    int count_words = 0;
    char *str = argv[1];
    str++;
    while(*str != '\0') {
        if (!is_space(*(str-1)) && is_space(*str)) {
            count_words++;
        }
        str++;
    }

    if (!is_space(*(str-1)) && *str == '\0') {
        count_words++;
    }

    printf("count words = %d\n", count_words);
    return 0;
}
