#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

typedef struct dirent dirent;

void find_file(char *dir_name, char *filename)
{
    DIR *dir = opendir(dir_name);
    if (dir == NULL) {
        perror("opendir");
        return;
    }

    dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        if ((strcmp(entry->d_name, ".") == 0) ||
            (strcmp(entry->d_name, "..") == 0)) {
            continue;
        }

        size_t s = strlen(entry->d_name) + strlen(dir_name) + 2;
        char *path = malloc(s * sizeof(char));
        if (!path) {
            perror("malloc");
            continue;
        }
        snprintf(path, s, "%s/%s", dir_name, entry->d_name);

        struct stat st;
        if (lstat(path, &st) == 0 && S_ISDIR(st.st_mode)) {
            find_file(path, filename);
        } else if (strcmp(entry->d_name, filename) == 0) {
            printf("%s/%s\n", dir_name, entry->d_name);
        }
        free(path);
    }

    closedir(dir);
}

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: %s <file_name>\n", argv[0]);
        return 1;
    }

    find_file(".", argv[1]);
    return 0;
}
