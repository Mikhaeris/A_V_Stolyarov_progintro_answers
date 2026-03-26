#include <stdio.h>
#include <stdlib.h>

#define false 0
#define true  1

typedef enum node_type {
    node_null = 0,
    node_word = 1,
    node_char = 2
} node_type;

typedef struct node {
    node_type type;
    union {
        char ch;
        struct {
            struct node *head_chars;
            struct node *tail_chars;
        };
    };
    struct node *next;
} node;

static node *node_init(node_type tp)
{
    node *new_node = calloc(1, sizeof(*new_node));
    if (new_node == NULL) {
        exit(1);
    }
    new_node->type = tp;
    new_node->next = NULL;
    return new_node;
}

static void list_free(node *head)
{
    while (head != NULL) {
        if (head->type == node_word) {
            list_free(head->head_chars);
        }
        node *tmp = head->next;
        free(head);
        head = tmp;
    }
}

static void list_push_back(node **n)
{
    const node *head = *n;
    if (head == NULL) {
        *n = node_init(node_word);
    } else {
        node *tmp = node_init(node_word);
        (*n)->next = tmp;
        *n = tmp;
    }
}

static void list_node_push_back(node *head, char c)
{
    if (head->head_chars == NULL) {
        head->head_chars     = node_init(node_char);
        head->head_chars->ch = c;
        head->tail_chars     = head->head_chars;
    } else {
        node *new_node = node_init(node_char);
        new_node->ch = c;
        head->tail_chars->next = new_node;
        head->tail_chars = new_node;
    }
}

static void list_print(node *head_main)
{
    int alive = 0;
    for (const node *h = head_main; h != NULL; h = h->next) {
        if (h->head_chars != NULL) {
            alive++;
        }
    }

    while (alive > 0) {
        node *head = head_main;
        while (head != NULL) {
            if (head->head_chars != NULL) {
                printf("%c", head->head_chars->ch);
                node *tmp = head->head_chars->next;
                if (head->head_chars == head->tail_chars) {
                    head->tail_chars = NULL;
                }
                free(head->head_chars);
                head->head_chars = tmp;
                if (head->head_chars == NULL) {
                    alive -= 1;
                }
            } else {
                printf(" ");
            }
            head = head->next;
        }
        printf("\n");
    }
}

static int is_space(char c)
{
    return (c == ' ' || c == '\t' || c == '\n');
}

int main()
{
    node *head = NULL;
    node *tail = NULL;
    int c;
    int prev_c = ' ';
    while ((c = getchar()) != EOF) {
        if (is_space(prev_c) && !is_space(c)) {
            list_push_back(&tail);
            if (head == NULL) {
                head = tail;
            }
        }

        if (!is_space(c)) {
            list_node_push_back(tail, c);
        }

        prev_c = c;

        if (c == '\n') {
            if (head != NULL) {
                list_print(head);
            }
            printf("\n");
            list_free(head);
            head = NULL;
            tail = NULL;
        }
    }

    if (head != NULL) {
        list_print(head);
        list_free(head);
        head = NULL;
        tail = NULL;
    }

    return 0;
}
