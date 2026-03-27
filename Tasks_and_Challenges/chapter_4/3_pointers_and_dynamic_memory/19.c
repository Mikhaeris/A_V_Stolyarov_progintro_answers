#include <stdio.h>
#include <stdlib.h>

#define false 0
#define true  1

typedef struct node {
    long val;
    struct node *next;
} node;

static node *node_init()
{
    node *new_node = malloc(sizeof(*new_node));
    if (new_node == NULL) {
        exit(1);
    }
    new_node->val  = 0;
    new_node->next = NULL;
    return new_node;
}

static void list_free(node *head)
{
    while (head != NULL) {
        node *tmp = head->next;
        free(head);
        head = tmp;
    }
}

static void list_push_back(node **n, long num)
{
    if (*n == NULL) {
        *n = node_init();
        (*n)->val = num;
    } else {
        node *tmp = node_init();
        (*n)->next = tmp;
        *n = tmp;
        (*n)->val = num;
    }
}

static long mod(long num)
{
    if (num < 0) {
        return -num;
    }
    return num;
}

static void list_print(const node *head)
{
    while (head != NULL && head->next != NULL) {
        if (mod(head->val - head->next->val) <= 5) {
            printf("%ld and %ld\n", head->val, head->next->val);
        }
        head = head->next;
    }
}


int main()
{
    node *head = NULL;
    node *tail = NULL;
    long num;
    long prev_num;
    int first = false;
    while (scanf("%ld", &num) != EOF) {
        if (first != false) {
            if (mod(num - prev_num) <= 5) {
                if (tail == NULL ||prev_num != tail->val) {
                    list_push_back(&tail, prev_num);
                }
                if (head == NULL) {
                    head = tail;
                }
                list_push_back(&tail, num);
            }
        }
        first = true;

        prev_num = num;
    }

    if (head != NULL) {
        printf("Ans:\n");
        list_print(head);
        list_free(head);
        head = NULL;
        tail = NULL;
    }

    return 0;
}
