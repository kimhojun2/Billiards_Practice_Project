#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>

const char* SERVER_IP = "52.79.251.189";
const char* SERVER_PORT = "30050";

int client_sock;
void interrupt(int arg) {
	printf("You typed ctrl + C.\nBye\n");

	close(client_sock);
	exit(1);
}

int main(int argc, char* argv[]) {
	signal(SIGINT, interrupt);

	client_sock = socket(AF_INET, SOCK_STREAM, 0);
       	if (client_sock == -1) {
	       	printf("ERROR::1 Socket error.\n");

		exit(1);
	}

	struct sockaddr_in server_addr = { 0 };
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = inet_addr(SERVER_IP);
	server_addr.sin_port = htons(atoi(SERVER_PORT));

	socklen_t server_addr_len = sizeof(server_addr);

	if (connect(client_sock, (struct sockaddr *)&server_addr, server_addr_len) == -1) {
		printf("ERROR::2 Connect error.\n");
		exit(1);
	}

	char buf[256];
	while (1) {
		memset(buf, 0, 256);
		scanf("%s", buf);
		if (!strcmp(buf, "exit")) {
			write(client_sock, buf, strlen(buf));
			break;
		}
		write(client_sock, buf, strlen(buf));
		sleep(2);

		memset(buf, 0, 256);
		int len = read(client_sock, buf, 255);
		if (len == 0) {
			printf("INFO::Server disconnected.\n");
			break;
		}
		printf("%s\n", buf);
	}

	close(client_sock);

	return 0;
}
