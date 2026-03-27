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
            long length;
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
    head->length += 1;
}

static long longest_num(node *head)
{
    long max_length = 0;
    while (head != NULL) {
        if (max_length < head->length) {
            max_length = head->length;
        }
        head = head->next;
    }
    return max_length;
}

static void list_print(node *head, long length)
{
    int first = true;
    while (head != NULL) {
        if (head->type == node_word && head->length == length) {
            if (!first) {
                printf(" ");
            }
            first = 0;
            list_print(head->head_chars, 0);
        } else if (head->type == node_char) {
            printf("%c", head->ch);
        }
        head = head->next;
    }
}

static int is_num(char c)
{
    return ('0' <= c && c <= '9');
}

int main()
{
    node *head = NULL;
    node *tail = NULL;
    int c;
    int prev_c = ' ';
    while ((c = getchar()) != EOF) {
        if (!is_num(prev_c) && is_num(c)) {
            list_push_back(&tail);
            if (head == NULL) {
                head = tail;
            }
        }

        if (is_num(c)) {
            list_node_push_back(tail, c);
        }

        prev_c = c;

        if (c == '\n') {
            if (head != NULL) {
                long max_length = longest_num(head);
                list_print(head, max_length);
            }
            printf("\n");
            list_free(head);
            head = NULL;
            tail = NULL;
        }
    }

    if (head != NULL) {
        long max_length = longest_num(head);
        list_print(head, max_length);
        list_free(head);
        head = NULL;
        tail = NULL;
    }

    return 0;
}
