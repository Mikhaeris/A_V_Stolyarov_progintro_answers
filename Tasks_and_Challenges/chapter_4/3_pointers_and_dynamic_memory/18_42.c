#include <stdio.h>
#include <stdlib.h>

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
    node *new_node = calloc(sizeof(*new_node), 1);
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

static void list_push_front(node **n)
{
    node *new_node = node_init(node_word);
    new_node->next = *n;
    *n             = new_node;
}

static void list_node_push_back(node *head, char c)
{
    if (head->head_chars == NULL) {
        head->head_chars     = node_init(node_char);
        head->head_chars->ch = c;
        head->tail_chars     = head->head_chars;
    } else {
        node *new_node         = node_init(node_char);
        new_node->ch           = c;
        head->tail_chars->next = new_node;
        head->tail_chars       = new_node;
    }
}

static void list_print(node *head)
{
    while (head != NULL) {
        if (head->type == node_word) {
            list_print(head->head_chars);
            if (head->next != NULL) {
                printf(" ");
            }
        } else if (head->type == node_char) {
            printf("%c", head->ch);
        }
        head = head->next;
    }
}

static int is_space(char c)
{
    return (c == ' ' || c == '\t' || c == '\n');
}

int main()
{
    node *head = NULL;
    int c;
    int prev_c = ' ';
    while ((c = getchar()) != EOF) {
        if (is_space(prev_c) && !is_space(c)) {
            list_push_front(&head);
        }

        if (!is_space(c)) {
            list_node_push_back(head, c);
        }

        prev_c = c;

        if (c == '\n') {
            if (head != NULL) {
                list_print(head);
            }
            printf("\n");
            list_free(head);
            head = NULL;
        }
    }

    if (head != NULL) {
        list_print(head);
        list_free(head);
        head = NULL;
    }

    return 0;
}
