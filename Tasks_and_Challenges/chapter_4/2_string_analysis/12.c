#include <stdio.h>

const char *substr(const char *str, const char *substr)
{
    while (*str != '\0') {
        const char *c_str = str;
        const char *c_substr = substr;
        while (*c_str == *c_substr && *c_substr != '\0') {
            c_str++;
            c_substr++;
        }
        if (*c_substr == '\0') {
            return str;
        }
        str++;
    }
    return NULL;
}

size_t get_length(const char *str)
{
    size_t length = 0;
    while (*str != '\0') {
        str++;
        length++;
    }
    return length;
}

int main(int argc, char **argv)
{
    if (argc < 3) {
        fprintf(stderr, "Error: too few args, need more than 1 args!\n");
        return 1;
    }

    const char *subs = argv[1];
    size_t subs_len = get_length(subs);
    for (int i = 2; i < argc; i++) {
        int count = 0;
        const char *str = argv[i];
        while ((str = substr(str, subs))) {
            count++;
            str += subs_len;
        }

        if (count) {
            printf("%s contains %s: %d times\n", argv[i], subs, count);
        }
    }

    return 0;
}
