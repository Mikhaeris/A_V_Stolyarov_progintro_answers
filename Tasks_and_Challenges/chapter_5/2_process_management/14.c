#include <stdio.h>
#include <sys/wait.h>

int main()
{
    while (waitpid(-1, NULL, WNOHANG) > 0)
        ;
    return 0;
}
