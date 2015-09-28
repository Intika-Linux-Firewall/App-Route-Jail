#include <sched.h>
#include <syscall.h>
#include <unistd.h>

/*

    Use this program to force specific resolv.conf for a program
    
    ./newns sh -c "mount -n --bind /tmp/resolvconf2 /etc/resolv.conf; /bin/wget http://example.com"

*/

int main(int argc, char *argv[]) {
  syscall(SYS_unshare, CLONE_NEWNS);
  if (argc > 1)
    return execvp(argv[1], &argv[1]);
  return execv("/bin/sh", NULL);
}
