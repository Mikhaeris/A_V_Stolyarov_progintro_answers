int count_spaces(const char *str)
{
    int spaces = 0;
    while (*str != '\0') {
        if (*str == ' ') {
            spaces++;
        }
        str++;
    }
    return spaces;
}

int main(int argc, char **argv)
{
    char *str = "some short str";
    int spaces = count_spaces(str);
    return 0;
}
