#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

typedef struct {
    int pid;
    char *name;
} pid_info;

typedef struct {
    int cap;
    int size;
    pid_info **pids;
} vec;

void vec_init(vec *v)
{
    v->size = 0;
    v->cap = 8;
    v->pids = malloc(sizeof(*v->pids) * v->cap);
}

void vec_free(vec *v)
{
    for (int i = 0; i < v->size; i++) {
        if (v->pids[i]) {
            free(v->pids[i]);
        }
    }
    free(v->pids);
}

void vec_add(vec *v, int pid, char *name)
{
    pid_info *pi = malloc(sizeof(*pi));
    if (!pi) {
        perror("malloc");
        exit(1);
    }
    pi->pid = pid;
    pi->name = name;

    if (v->size >= v->cap) {
        v->cap *= 2;
        void *tmp = realloc(v->pids, sizeof(*v->pids) * v->cap);
        if (!tmp) {
            perror("malloc");
            exit(1);
        }
        v->pids = tmp;
    }

    v->pids[v->size] = pi;
    v->size += 1;
}

char *vec_find_by_pid(vec *v, int pid)
{
    for (int i = 0; i < v->size; i++) {
        if (v->pids[i]->pid == pid) {
            return v->pids[i]->name;
        }
    }
    return NULL;
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "usage: %s <prog_name> ...\n", argv[0]);
        return 1;
    }
    vec v;
    vec_init(&v);

    int start = 1;
    int children = 0;
    for (int i = 1; i <= argc; i++) {
        if (i == argc || strcmp(argv[i], ";;") == 0) {
            argv[i] = NULL;

            if (i > start) {
                int pid = fork();
                if (pid == -1) {
                    perror("fork");
                    continue;
                }
                if (pid == 0) {
                    execvp(argv[start], argv + start);
                    perror("execvp");
                    exit(1);
                }
                vec_add(&v, pid, argv[start]);
                children += 1;
            }

            start = i + 1;
        }
    }

    int status;
    for (int i = 0; i < children; i++) {
        pid_t pid = wait(&status);
        if (pid == -1) {
            perror("wait");
            break;
        }
        if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
            char *name = vec_find_by_pid(&v, pid);
            if (name) {
                printf("%s\n", name);
                fflush(stdout);
            }
        }
    }

    vec_free(&v);

    return 0;
}
