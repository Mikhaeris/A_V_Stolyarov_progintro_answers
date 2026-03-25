#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    long val;
    long count;
    struct node *next;
} node;

static node *node_init(long val)
{
    node* new_node = malloc(sizeof(node));
    if (new_node == NULL) {
        exit(1);
    }
    new_node->val   = val;
    new_node->count = 1;
    new_node->next  = NULL;
    return new_node;
}

static void list_add(node **head, long val)
{
    node *cur = *head;
    node *prev = NULL;
    while (cur != NULL) {
        if (cur->val == val) {
            cur->count += 1;
            return;
        }
        prev = cur;
        cur= cur->next;
    }

    if (prev != NULL) {
        prev->next = node_init(val);
    } else {
        *head = node_init(val);
    }
}

static void list_free(node *head)
{
    while (head != NULL) {
        node *tmp = head->next;
        free(head);
        head = tmp;
    }
}

static void list_print_val_equal_three(const node *head)
{
    while (head != NULL) {
        if (head->count == 3) {
            if (head->next == NULL) {
                printf("%ld", head->val);
            } else {
                printf("%ld ", head->val);
            }
        }
        head = head->next;
    }
}

int main()
{
    node *head = NULL;
    long num;
    while (scanf("%ld", &num) == 1) {
        list_add(&head, num);
    }

    list_print_val_equal_three(head);
    printf("\n");

    list_free(head);
    return 0;
}
