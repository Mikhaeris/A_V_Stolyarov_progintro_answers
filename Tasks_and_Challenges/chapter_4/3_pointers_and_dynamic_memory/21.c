#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct stackdbl {
    size_t size;
    size_t capacity;
    void *data;
} stackdbl;

static stackdbl *stackdbl_init()
{
    stackdbl *new_stackdbl = malloc(sizeof(*new_stackdbl));
    if (new_stackdbl == NULL) {
        fprintf(stderr, "Bad alloc!");
        exit(1);
    }

    new_stackdbl->size = 0;
    new_stackdbl->capacity = 2;
    new_stackdbl->data = malloc(sizeof(double) * new_stackdbl->capacity);

    if (new_stackdbl->data == NULL) {
        fprintf(stderr, "Bad alloc!");
        exit(1);
    }

    return new_stackdbl;
}

static void stackdbl_destroy(stackdbl *stackdbl)
{
    free(stackdbl->data);
    free(stackdbl);
}

static void stackdbl_realloc(stackdbl *stackdbl)
{
    stackdbl->capacity *= 2;

    void *new_data = malloc(sizeof(double) * stackdbl->capacity);
    if (new_data == NULL) {
        fprintf(stderr, "Bad alloc!");
        exit(1);
    }

    memcpy(new_data, stackdbl->data, sizeof(double) * stackdbl->size);
    free(stackdbl->data);

    stackdbl->data = new_data;
}

static void stackdbl_push(stackdbl *stackdbl, double num)
{
    if (stackdbl->size >= stackdbl->capacity) {
        stackdbl_realloc(stackdbl);
    }

    void *pos = (char *)stackdbl->data + (sizeof(double) * stackdbl->size);
    *(double *)pos = num;

    stackdbl->size += 1;
}

static void stackdbl_pop(stackdbl *stackdbl)
{
    if (stackdbl->size == 0) {
        return;
    }

    stackdbl->size -= 1;
}

static double stackdbl_top(stackdbl *stackdbl)
{
    if (stackdbl->size == 0) {
        return 0.0;
    }
    const double *pos = (double *)stackdbl->data + (stackdbl->size-1);

    return *pos;
}

static int stackdbl_empty(const stackdbl *stackdbl)
{
    return stackdbl->size == 0;
}

int main()
{
    stackdbl *my_stackdbl = stackdbl_init();

    stackdbl_push(my_stackdbl, 10.1);
    stackdbl_push(my_stackdbl, 5.7);
    stackdbl_push(my_stackdbl, 7.2);

    printf("%f\n", stackdbl_top(my_stackdbl));

    stackdbl_pop(my_stackdbl);

    printf("%f\n", stackdbl_top(my_stackdbl));

    printf("Empty: %s\n", stackdbl_empty(my_stackdbl) ? "True" : "False");

    stackdbl_destroy(my_stackdbl);
    return 0;
}
