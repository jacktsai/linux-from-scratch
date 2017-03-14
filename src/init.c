#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <linux/bpf.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <stddef.h>
#include <sys/epoll.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	mkdir("/dev", 0755);

    int i;
	for (i = 0; i < 10; i++) {
		printf("Hello World!\n");
		sleep(1);
	}

	return 0;
}

