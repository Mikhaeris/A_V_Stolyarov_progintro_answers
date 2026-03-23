#include <stdio.h>
#include <stdlib.h>

typedef struct item {
    int x;
    struct item *next;
} item;

static item *arr_to_list(const int *arr, size_t n)
{
    item *head = NULL;
    item **pp = &head;

    for (size_t i = 0; i < n; i++) {
        *pp = malloc(sizeof(item));
        if (*pp == NULL) {
            exit(1);
        }

        (*pp)->x = arr[i];
        (*pp)->next = NULL;

        pp = &(*pp)->next;
    }

    return head;
}

static size_t get_list_size(const item *head)
{
    size_t size = 0;
    while (head != NULL) {
        head = head->next;
        size++;
    }
    return size;
}

static int *list_to_arr(const item *head)
{
    size_t list_size = get_list_size(head);
    int *arr = malloc((list_size + 1) * sizeof(int));
    if (arr == NULL) {
        exit(1);
    }
    /* size_t to int??? */
    arr[0] = (int)list_size;
    for (size_t i = 1; head != NULL; i++) {
        arr[i] = head->x;
        head = head->next;
    }
    return arr;
}

static void list_print(const item *head)
{
    while (head != NULL) {
        if (head->next != NULL) {
            printf("%d ", head->x);
        } else {
            printf("%d", head->x);
        }

        head = head->next;
    }
    printf("\n");
}

static void list_free(item *head)
{
    while (head != NULL) {
        item *tmp = head->next;
        free(head);
        head = tmp;
    }
}

static void arr_print(const int *arr, size_t arr_len)
{
    for (size_t i = 0; i < arr_len; i++) {
        if (i == arr_len-1) {
            printf("%d", arr[i]);
            break;
        }
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main()
{
    int arr[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    size_t arr_len = sizeof(arr)/sizeof(arr[0]);

    printf("init arr:\n");
    arr_print(arr, arr_len);

    item *head = arr_to_list(arr, arr_len);
    printf("arr to list:\n");
    list_print(head);

    int *arr2 = list_to_arr(head);
    printf("list to arr:\n");
    arr_print(arr2+1, arr2[0]);

    free(arr2);
    list_free(head);

    return 0;
}
