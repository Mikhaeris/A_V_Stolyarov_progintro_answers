#include <stdint.h>
#include <stdio.h>

#define false 0
#define true  1

int main(int argc, char **argv)
{
    /* temp */
    int word_length = 0;
    int flag_rw = false;
    int cur_space_length = 0;

    /* a */
    int count_words = 0;

    /* b */
    int c_even = 0;
    int c_odd = 0;

    /* c */
    int cw_mtsev = 0;
    int cw_lttwo = 0;

    /* d */
    int cw_sA_eZ = 0;

    /* f */
    int longest_space_length = 0;

    /* c */
    int longest_words_length = 0;
    int shortest_words_length = INT32_MAX;

    /* g */
    int count_parentheses = 0;
    int parentheses_flag = true;

    /* h */
    int count_parentheses_oc = 0;


    int c;
    int prev_c = ' ';
    while ((c = getchar()) != EOF) {
        /* start word */
        /* a */
        if ((prev_c == ' ' || prev_c == '\t') && !(c != ' ' || c != '\t')) {
            count_words++;

            /* d */
            if (c == 'A') {
                flag_rw = true;
            }
        }

        /* end word */
        /* b */
        if (!(prev_c == ' ' || prev_c == '\t') && (c == ' ' || c == '\t' || c == '\n')) {
            if (word_length % 2 == 0) {
                c_even++;
            } else {
                c_odd++;
            }

            /* c */
            if (word_length > 7) {
                cw_mtsev++;
            } else if (word_length <= 2) {
                cw_lttwo++;
            }

            /* d */
            if (prev_c == 'Z' && flag_rw == true) {
                cw_sA_eZ++;
            }
            flag_rw = false;

            /* e */
            if (longest_words_length < word_length) {
                longest_words_length = word_length;
            }
            if (shortest_words_length > word_length) {
                shortest_words_length = word_length;
            }

            word_length = 0;
        } else {
            word_length++;
        }

        /* f */
        if (c == ' ' || c == '\t') {
            cur_space_length++;
        } else {
            if (longest_space_length < cur_space_length) {
                longest_space_length = cur_space_length;
            }
            cur_space_length = 0;
        }

        /* g */
        if (c == '(') {
            count_parentheses++;
        } else if (c == ')') {
            count_parentheses--;
            if (count_parentheses < 0) {
                parentheses_flag = false;
            }
        }

        /* h */
        if (prev_c == '(' && c == ')') {
            count_parentheses_oc++;
        }

        if (c == '\n') {
            printf("Condition a) %d\n", count_words);
            printf("Condition b) count words even: %d odd: %d\n",
                                                        c_even, c_odd);
            printf("Condition c) count words more then seven: %d"
                                "less or equal two: %d\n", c_even, c_odd);
            printf("Condition d) count word start A and end Z: %d\n",
                                                        cw_sA_eZ);
            printf("Condition e) count words: %d,"
                    "longest word length: %d, shortest word length: %d\n",
                    count_words, longest_words_length, shortest_words_length);

            printf("Condition f) longest word length: %d,"
                    " longest space length: %d\n",
                    longest_words_length, longest_space_length);

            printf("Condition g) correct bracket sequence %s\n",
                    (parentheses_flag) ? "YES" : "NO");

            printf("Condition h) count opend and close paretheses %d\n",
                   count_parentheses_oc);

            /* reset */
            /* temp */
            int word_length = 0;
            int flag_rw = false;
            int cur_space_length = 0;

            /* a */
            int count_words = 0;

            /* b */
            int c_even = 0;
            int c_odd = 0;

            /* c */
            int cw_mtsev = 0;
            int cw_lttwo = 0;

            /* d */
            int cw_sA_eZ = 0;

            /* f */
            int longest_space_length = 0;

            /* c */
            int longest_words_length = 0;
            int shortest_words_length = INT32_MAX;

            /* g */
            int count_parentheses = 0;
            int parentheses_flag = true;

            /* h */
            int count_parentheses_oc = 0;
        }

        prev_c = c;
    }

    return 0;
}
