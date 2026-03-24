#include <stdio.h>
#include <stdlib.h>

typedef struct item {
    int x;
    struct item *next;
} item;

static item *arr_to_list(const int *arr, size_t n)
{
    if (n == 0) {
        return NULL;
    }
    item *head = malloc(sizeof(*head));
    if (head == NULL) {
        exit(1);
    }
    head->x = *arr;
    head->next = arr_to_list(arr+1, n-1);
    return head;
}

static size_t get_list_size(const item *head)
{
    if (head == NULL) {
        return 0;
    }
    return get_list_size(head->next) + 1;
}

static void lta_rec(int *arr, const item *head)
{
    if (head == NULL) {
        return;
    }
    *arr = head->x;
    lta_rec(arr+1, head->next);
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
    lta_rec(arr+1, head);
    return arr;
}

static void list_print(const item *head)
{
    if (head == NULL) {
        printf("\n");
        return;
    }

    if (head->next == NULL) {
        printf("%d", head->x);
    } else {
        printf("%d ", head->x);
    }

    list_print(head->next);
}

static void list_free(item *head)
{
    if (head == NULL) {
        return;
    }
    list_free(head->next);
    free(head);
}

static void arr_print(const int *arr, size_t arr_len)
{
    if (arr_len == 0) {
        printf("\n");
        return;
    }

    if (arr_len-1 == 0) {
        printf("%d", *arr);
    } else {
        printf("%d ", *arr);
    }

    arr_print(arr+1, arr_len-1);
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
