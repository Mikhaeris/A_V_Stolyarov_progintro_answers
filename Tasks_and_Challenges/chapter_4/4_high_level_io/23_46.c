#include <stdio.h>
#include <stdlib.h>

void write_poem(FILE *file)
{
    fprintf(file, "Humpty Dumpty sat on a wall\n");
    fprintf(file, "Humpty Dumpty had a great fall\n");
    fprintf(file, "All the king's horses and all the king's men\n");
    fprintf(file, "Couldn't put Humpty together again\n");
    fprintf(file, "\n");
    fprintf(file, "Humpty Dumpty sat on the ground\n");
    fprintf(file, "Humpty Dumpty looked all around\n");
    fprintf(file, "Gone were the chimneys, gone were the rooves\n");
    fprintf(file, "All he could see were buckles and hooves\n");
    fprintf(file, "\n");
    fprintf(file, "More of Dumpty\n");
    fprintf(file, "More of Dumpty\n");
    fprintf(file, "More of Dumpty\n");
    fprintf(file, "Dumpty\n");
    fprintf(file, "\n");
    fprintf(file, "More of Dumpty\n");
    fprintf(file, "More of Dumpty\n");
    fprintf(file, "More of Dumpty\n");
    fprintf(file, "More of Dumpty, Dumpty\n");
    fprintf(file, "\n");
    fprintf(file, "Humpty Dumpty counted to ten\n");
    fprintf(file, "Humpty Dumpty brought out a pen\n");
    fprintf(file, "All the King's horses and all the King's men\n");
    fprintf(file, "Were happy that Humpty's together again.\n");
}

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

    write_poem(file);

    return 0;
}
