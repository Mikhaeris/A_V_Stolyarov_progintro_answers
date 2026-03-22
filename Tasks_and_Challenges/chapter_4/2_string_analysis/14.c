#include <stdio.h>

void delete_spaces(char *str)
{
    size_t f = 0;
    size_t s = 0;
    while (str[s] != '\0') {
        if (str[s] != ' ') {
            str[f] = str[s];
            f++;
        }
        s++;
    }
    str[f] = '\0';
}

int main(int argc, char **argv)
{
    char str[] = "Hello  world, world    !";
    printf("Before: %s\n", str);
    delete_spaces(str);
    printf("After: %s\n", str);
    return 0;
}
