int put_sum(int *a, int *b, int *c)
{
    int sum = 0;
    sum += *a;
    sum += *b;
    sum += *c;

    *a = sum;
    *b = sum;
    *c = sum;

    return sum;
}

int main(int argc, char **argv)
{
    int a = 10;
    int b = 20;
    int c = 30;
    int sum = put_sum(&a, &b, &c);
    return 0;
}
