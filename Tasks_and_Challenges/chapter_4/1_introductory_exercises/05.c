int get_ans_zero(int *n)
{
    int tmp = *n;
    *n = 0;
    return tmp;
}

int main(int argc, char **argv)
{
    int n = 10;
    int ans = get_ans_zero(&n);
    return 0;
}
