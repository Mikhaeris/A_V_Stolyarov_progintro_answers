#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

typedef struct dirent dirent;
typedef struct stat stats;

void print_stat(stats *st)
{
    const char *type;
    if (S_ISREG(st->st_mode))
        type = "regular file";
    else if (S_ISDIR(st->st_mode))
        type = "directory";
    else if (S_ISLNK(st->st_mode))
        type = "symbolic link";
    else if (S_ISCHR(st->st_mode))
        type = "character device";
    else if (S_ISBLK(st->st_mode))
        type = "block device";
    else if (S_ISFIFO(st->st_mode))
        type = "FIFO/pipe";
    else if (S_ISSOCK(st->st_mode))
        type = "socket";
    else
        type = "unknown";
    printf("type:      %s\n", type);

    printf("tst_dev: %d\n", st->st_dev);
    printf("tst_mode: %d\n", st->st_mode);
    printf("tst_nlink: %d\n", st->st_nlink);
    printf("tst_ino: %llu\n", st->st_ino);
    printf("tst_uid: %d\n", st->st_uid);
    printf("tst_gid: %d\n", st->st_gid);
    printf("tst_rdev: %d\n", st->st_rdev);
#ifdef __APPLE__
    printf("tst_atimespec.tv_sec: %ld\n", st->st_atimespec.tv_sec);
    printf("tst_atimespec.tv_nsec: %ld\n", st->st_atimespec.tv_nsec);
    printf("tst_mtimespec.tv_sec: %ld\n", st->st_mtimespec.tv_sec);
    printf("tst_mtimespec.tv_nsec: %ld\n", st->st_mtimespec.tv_nsec);
    printf("tst_ctimespec.tv_sec: %ld\n", st->st_ctimespec.tv_sec);
    printf("tst_ctimespec.tv_nsec: %ld\n", st->st_ctimespec.tv_nsec);
    printf("tst_birthtimespec.tv_sec: %ld\n", st->st_birthtimespec.tv_sec);
    printf("tst_birthtimespec.tv_nsec: %ld\n", st->st_birthtimespec.tv_nsec);
#endif
    printf("tst_size: %lld\n", st->st_size);
    printf("tst_blocks: %lld\n", st->st_blocks);
    printf("tst_blksize: %d\n", st->st_blksize);
#ifdef __APPLE__
    printf("tst_flags: %d\n", st->st_flags);
    printf("tst_gen: %d\n", st->st_gen);
#endif
}

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

        stats st;
        if (lstat(path, &st) == 0 && S_ISDIR(st.st_mode)) {
            find_file(path, filename);
        } else if (strcmp(entry->d_name, filename) == 0) {
            print_stat(&st);
            if (S_ISLNK(st.st_mode)) {
                stats target_st;
                if (stat(path, &target_st) == -1) {
                    printf("dangling\n");
                } else {
                    print_stat(&target_st);
                }
            }
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
