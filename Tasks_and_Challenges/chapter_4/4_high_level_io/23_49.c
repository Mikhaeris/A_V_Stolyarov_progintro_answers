#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    if (argc != 2) {
        printf("Usage: prog <file_name>\n");
        return 0;
    }

    FILE *file = fopen(argv[1], "w");
    if (file == NULL) {
        fprintf(stderr, "Error: couldn't open the file - %s\n", argv[1]);
        return 1;
    }

    int c;
    while ((c = getchar()) != EOF) {
        fprintf(file, "%c", c);
    }

    return 0;
}
