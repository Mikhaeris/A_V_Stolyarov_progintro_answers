#include <stdio.h>

#define false 0
#define true  1

int is_space(char c) {
    return (c == ' ' || c == '\t' || c == '\n');
}

int main(int argc, char **argv)
{
    enum { arr_len = 2 };
    char arr[arr_len] = {0};

    int word_length = 0;
    int in_word = false;

    int j = 0;
    int c;
    while ((c = getchar()) != EOF) {
        if (!is_space(c)) {
            word_length++;
            in_word = true;
        } else {
            in_word = false;
        }

        if (in_word) {
            arr[j] = c;
            j ^= 1;
        }

        if (word_length == 2 && in_word == false) {
            for (int i = 0; i < arr_len; i++) {
                putchar(arr[i]);
            }
            word_length = 0;
        }

        if (c == ' ' || c == '\t' || c == '\n') {
            putchar(c);
            word_length = 0;
            j = 0;
        }

    }

    return 0;
}
