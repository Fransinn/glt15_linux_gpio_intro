#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <poll.h>

#define MAX_BUF 64

int main(int argc, char **argv, char **envp)
{
  struct pollfd fdset[1];
  int nfds = 1;
  int gpio_fd, timeout, rc;
  int len;
  char buf[MAX_BUF];

  if (argc < 2) {
    printf("Usage: %s <file>\n\n",argv[0]);
    printf("Waits for a change in the GPIO pin voltage level or input on stdin\n");
    exit(-1);
  }

  gpio_fd = open(argv[1],O_RDONLY | O_NONBLOCK );
  if (gpio_fd < 0) {
    perror("file open");
  }

  timeout = -1;
 
  int num_break = 2;

  while (1) {
    memset((void*)fdset, 0, sizeof(fdset));

    fdset[0].fd = gpio_fd;
    fdset[0].events = POLLPRI;

    rc = poll(fdset, nfds, timeout);

    if (rc < 0) {
      printf("\npoll() failed!\n");
      return -1;
    }

    printf(".");

    if (fdset[0].revents & POLLPRI) {
      len = read(fdset[0].fd, buf, MAX_BUF);
      printf("poll() %s interrupt occurred\n", argv[1]);
      num_break--;
      if (num_break <= 0)
        break;
    }

    fflush(stdout);
  }

  close(gpio_fd);
  if (num_break <= 0)
    return 0;
  else 
    return 1;
}
