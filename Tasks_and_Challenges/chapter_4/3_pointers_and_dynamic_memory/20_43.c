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

static inline int is_space(char c)
{
    return (c == ' ' || c == '\t' || c == '\n');
}

static void vec_words_print(vec *vec_words)
{
    size_t max_size = 0;
    for (size_t i = 0; i < vec_words->size; i++) {
        const vec *vec_chars = *(vec **)vec_at(vec_words, i);
        size_t cur_size = vec_chars->size;
        if (max_size < cur_size) {
            max_size = cur_size;
        }
    }

    for (size_t i = 0; i < max_size; i++) {
        for (size_t j = 0; j < vec_words->size; j++) {
            vec *vec_chars = *(vec **)vec_at(vec_words, j);
            if (i < vec_chars->size) {
                printf("%c", *(char *)vec_at(vec_chars, i));
            } else {
                printf(" ");
            }
        }
        printf("\n");
    }
}

static void vec_words_free(vec *vec_words)
{
    for (size_t i = 0; i < vec_words->size; i++) {
        vec_free(*(vec **)vec_at(vec_words, i));
    }
    vec_words->size = 0;
}


int main()
{
    vec *vec_words = vec_init(sizeof(vec *));

    int c;
    int prev_c = ' ';
    while ((c = getchar()) != EOF) {
        if (is_space(prev_c) && !is_space(c)) {
            *(vec **)vec_push_back(vec_words) = vec_init(sizeof(char));
        }

        if (!is_space(c)) {
            vec *vec_chars = *(vec **)vec_at(vec_words, vec_words->size-1);
            *(char *)vec_push_back(vec_chars) = c;
        }

        if (c == '\n') {
            vec_words_print(vec_words);
            vec_words_free(vec_words);
        }

        prev_c = c;
    }

    if (vec_words->size != 0) {
        vec_words_print(vec_words);
        vec_words_free(vec_words);
    }

    free(vec_words);
}
