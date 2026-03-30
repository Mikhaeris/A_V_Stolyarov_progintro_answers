#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { base_capacity = 2 };
typedef struct header {
    size_t size;
    size_t capacity;
    size_t type_size;
} header;

#define GET_HEAD(VEC) (((header *)(VEC)) - 1)

/* in memory: [header][data]
 *                    ^
 *                    return this pointer
 * */
static void *vec_init(size_t type_size)
{
    void *buf = malloc(sizeof(header) + type_size * base_capacity);
    if (buf == NULL) {
        exit(1);
    }

    header *head_ptr = buf;
    head_ptr->size      = 0;
    head_ptr->capacity  = base_capacity;
    head_ptr->type_size = type_size;

    void *str = (char *)buf + sizeof(header);

    return str;
}

static void vec_free(void *vec)
{
    free(GET_HEAD(vec));
}

static void vec_realloc(void **vec, size_t new_capacity)
{
    header *head = GET_HEAD(*vec);
    if (head->size > new_capacity) {
        return;
    }
    head->capacity = new_capacity;

    void *new_head = malloc(sizeof(header) + head->type_size * head->capacity);
    if (new_head == NULL) {
        exit(1);
    }

    memcpy(new_head, head, sizeof(header) + (head->type_size * head->size));

    *vec = (char *)new_head + sizeof(header);
    free(head);
}

#define vec_push_back(VEC) (vec_push_back_impl((void **)&VEC))

static void *vec_push_back_impl(void **vec)
{
    header *head = GET_HEAD(*vec);
    if (head->size >= head->capacity) {
        vec_realloc(vec, head->capacity*2);
        head = GET_HEAD(*vec);
    }

    void *where = (char *)*vec + (head->type_size * head->size);

    head->size += 1;

    return where;
}

static void vec_pop_back(void *vec)
{
    header *head = GET_HEAD(vec);
    if (head->size != 0) {
        head->size -= 1;
    }
}

static size_t vec_size(void *vec)
{
    const header *head = GET_HEAD(vec);
    return head->size;
}

static int is_space(char c)
{
    return (c == ' ' || c == '\t' || c == '\n');
}

static void print_vec_strs(char **vec)
{
    size_t i = vec_size(vec);
    while (i > 0) {
        --i;
        fwrite(vec[i], vec_size(vec[i]), 1, stdout);
        if (i != 0) {
            printf(" ");
        }
    }
    printf("\n");
}

int main()
{
    char **words = vec_init(sizeof(char *));

    int c;
    int prev_c = ' ';
    while ((c = getchar()) != EOF) {
        /* word start*/
        if (is_space(prev_c) && !is_space(c)) {
            *(char **)vec_push_back(words) = vec_init(sizeof(char));
        }

        if (!is_space(c)) {
            *(char *)vec_push_back(words[vec_size(words)-1]) = c;
        }

        if (c == '\n') {
            print_vec_strs(words);
            while (vec_size(words) > 0) {
                vec_free(words[vec_size(words) - 1]);
                vec_pop_back(words);
            }
        }

        prev_c = c;
    }

    if (vec_size(words) != 0) {
        printf("\n");
        print_vec_strs(words);
        for (size_t i = 0; i < vec_size(words); i++) {
            vec_free(words[i]);
        }
    }

    vec_free(words);

    return 0;
}
