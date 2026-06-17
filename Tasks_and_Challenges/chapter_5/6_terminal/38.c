#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <syslog.h>
#include <time.h>
#include <unistd.h>

#ifndef LOGFILE
#define LOGFILE "/tmp/daemon_5_37.log"
#endif
#ifndef INTERVAL
#define INTERVAL 300
#endif

static const char *WHOAMI = "daemon 5.38";

static volatile sig_atomic_t got_alarm = 0;
static volatile sig_atomic_t got_usr1 = 0;
static volatile sig_atomic_t usr1_count = 0;

static void on_alarm(int sig)
{
    (void)sig;
    got_alarm = 1;
}
static void on_usr1(int sig)
{
    (void)sig;
    usr1_count++;
    got_usr1 = 1;
}

static void emit_status(int fd, time_t start, const char *reason)
{
    char msg[256];
    long up = (long)(time(NULL) - start);
    int n = snprintf(msg,
                     sizeof msg,
                     "%s: pid=%ld, uptime=%lds, SIGUSR1 received=%d [%s]",
                     WHOAMI,
                     (long)getpid(),
                     up,
                     (int)usr1_count,
                     reason);
    if (n < 0)
        return;
    size_t len = (n >= (int)sizeof msg) ? sizeof msg - 1 : (size_t)n;

    char fileline[sizeof msg + 1];
    memcpy(fileline, msg, len);
    fileline[len] = '\n';
    write(fd, fileline, len + 1);

    syslog(LOG_INFO, "%s", msg);
}

int main(void)
{
    pid_t pid = fork();
    if (pid < 0)
        _exit(1);
    if (pid > 0)
        _exit(0);
    if (setsid() < 0)
        _exit(1);
    pid = fork();
    if (pid < 0)
        _exit(1);
    if (pid > 0)
        _exit(0);

    umask(0);
    if (chdir("/") < 0)
        _exit(1);
    close(0);
    close(1);
    close(2);
    open("/dev/null", O_RDONLY);
    open("/dev/null", O_WRONLY);
    open("/dev/null", O_WRONLY);

    int fd = open(LOGFILE, O_WRONLY | O_CREAT | O_APPEND, 0666);
    if (fd < 0)
        _exit(1);

    openlog("daemon-5.38", LOG_NDELAY, LOG_DAEMON);

    struct sigaction sa;
    memset(&sa, 0, sizeof sa);
    sigemptyset(&sa.sa_mask);
    sa.sa_handler = on_alarm;
    sigaction(SIGALRM, &sa, NULL);
    sa.sa_handler = on_usr1;
    sigaction(SIGUSR1, &sa, NULL);

    time_t start = time(NULL);
    syslog(LOG_NOTICE,
           "%s started (pid=%ld), logging to %s",
           WHOAMI,
           (long)getpid(),
           LOGFILE);
    emit_status(fd, start, "startup");

    struct itimerval it;
    it.it_value.tv_sec = INTERVAL;
    it.it_value.tv_usec = 0;
    it.it_interval.tv_sec = INTERVAL;
    it.it_interval.tv_usec = 0;
    setitimer(ITIMER_REAL, &it, NULL);

    sigset_t block, empty;
    sigemptyset(&block);
    sigaddset(&block, SIGALRM);
    sigaddset(&block, SIGUSR1);
    sigprocmask(SIG_BLOCK, &block, NULL);
    sigemptyset(&empty);

    for (;;) {
        while (!got_alarm && !got_usr1)
            sigsuspend(&empty);
        if (got_usr1) {
            got_usr1 = 0;
            emit_status(fd, start, "SIGUSR1");
        }
        if (got_alarm) {
            got_alarm = 0;
            emit_status(fd, start, "timer");
        }
    }
}
