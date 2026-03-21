int count_spaces(const char *str)
{
    if (*str == '\0') {
        return 0;
    }

    return (*str == ' ') + count_spaces(str + 1);
}

int main(int argc, char **argv)
{
    char *str = "some short str";
    int spaces = count_spaces(str);
    return 0;
}
