/* TODO f and next */
#include <stdint.h>
#include <stdio.h>

#define false 0
#define true  1

int main(int argc, char **argv)
{
    /* temp */
    int word_length = 0;
    int flag_rw = false;

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

    /* c */
    int longest_wrods_length = 0;
    int shortest_words_length = INT32_MAX;


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
        if (!(prev_c == ' ' || prev_c == '\t') && (c == ' ' || c == '\t' || c == '\n')) {
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
                   count_words, longest_wrods_length, shortest_words_length);
        }

        /* end word */
        /* b */
        if (c == ' ' || c == '\t' || c == '\n') {
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
            if (longest_wrods_length < word_length) {
                longest_wrods_length = word_length;
            }
            if (shortest_words_length > word_length) {
                shortest_words_length = word_length;
            }

            word_length = 0;
        } else {
            word_length++;
        }

        prev_c = c;
    }

    return 0;
}
