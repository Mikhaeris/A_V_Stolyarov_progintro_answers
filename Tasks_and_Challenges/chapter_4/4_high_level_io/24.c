#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct vec {
    size_t size;
    size_t capacity;
    size_t type_size;
    void *data;
} vec;

static vec *vec_init(size_t type_size)
{
    vec *new_vec = malloc(sizeof(*new_vec));
    if (new_vec == NULL) {
        fprintf(stderr, "Bad alloc!\n");
        exit(1);
    }

    new_vec->size      = 0;
    new_vec->capacity  = 2;
    new_vec->type_size = type_size;
    new_vec->data      = malloc(new_vec->type_size * new_vec->capacity);

    if (new_vec->data == NULL) {
        fprintf(stderr, "Bad alloc!\n");
        exit(1);
    }

    return new_vec;
}

static void vec_free(vec *vec)
{
    free(vec->data);
    free(vec);
}

static void vec_realloc(vec *vec)
{
    vec->capacity *= 2;

    void *new_data = malloc(vec->type_size * vec->capacity);
    if (new_data == NULL) {
        fprintf(stderr, "Bad alloc!\n");
        exit(1);
    }

    memcpy(new_data, vec->data, vec->type_size * vec->size);
    free(vec->data);

    vec->data = new_data;
}

static void *vec_push_back(vec *vec)
{
    if (vec->size >= vec->capacity) {
        vec_realloc(vec);
    }

    void *where = (char *)vec->data + (vec->type_size * vec->size);
    vec->size += 1;
    return where;
}

static void *vec_at(vec *vec, size_t pos)
{
    if (pos >= vec->size) {
        fprintf(stderr, "Out of range!\n");
        exit(1);
    }

    return (char *)vec->data + (vec->type_size * pos);
}

static void flush_line(vec *vec_max_len, vec **line,
                       size_t file_idx, size_t *max_len)
{
    vec *cur = *line;
    if (cur->size > *max_len) {
        *max_len = cur->size;
    }

    if (vec_max_len->size == file_idx) {
        *(vec **)vec_push_back(vec_max_len) = cur;
    } else {
        vec *best = *(vec **)vec_at(vec_max_len, file_idx);
        if (cur->size > best->size) {
            vec_free(best);
            *(vec **)vec_at(vec_max_len, file_idx) = cur;
        } else {
            vec_free(cur);
        }
    }

    *line = vec_init(sizeof(char));
}

int main(int argc, char **argv)
{
    vec *vec_max_len = vec_init(sizeof(vec *));

    size_t max_len = 0;
    int file_idx = 0;
    for (int i = 1; i < argc; i++) {
        FILE *file = fopen(argv[i], "r");
        if (file == NULL) {
            fprintf(stderr, "Error: couldn't open the file - %s\n", argv[i]);
            continue;
        }


        vec *line = vec_init(sizeof(char));

        int c;
        while ((c = fgetc(file)) != EOF) {
            if (c == '\n') {
                flush_line(vec_max_len, &line, file_idx, &max_len);
            } else {
                *(char *)vec_push_back(line) = c;
            }
        }

        if (line->size > 0) {
            flush_line(vec_max_len, &line, file_idx, &max_len);
        } else {
            vec_free(line);
        }

        fclose(file);
        file_idx += 1;
    }

    for (size_t i = 0; i < vec_max_len->size; i++) {
        const vec *line = *(vec **)vec_at(vec_max_len, i);
        if (line->size == max_len) {
            printf("*");
        }
        printf("%s: ", argv[i+1]);

        fwrite(line->data, sizeof(char), line->size, stdout);
        printf("\n");
    }

    for (size_t i = 0; i < vec_max_len->size; i++) {
         vec *line = *(vec **)vec_at(vec_max_len, i);
        vec_free(line);
    }
    vec_free(vec_max_len);

    return 0;
}
