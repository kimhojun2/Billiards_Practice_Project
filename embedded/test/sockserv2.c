#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

const char* PORT = "30050";

int server_sock;
int client_sock;

void interrupt(int arg) {
	printf("You typed ctrl + C\n");
	printf("Bye\n");

	close(client_sock);
	close(server_sock);
	exit(1);
}

void removeEnterChar(char* buf) {
	int len = strlen(buf);
	for (int i = len - 1; i >= 0; --i) {
		if (buf[i] == '\n') {
			buf[i] = '\0';
			break;
		}
	}
}

void prefixingMessage(char* buf) {
	int len = strlen(buf);
	for (int i = len - 1; i >= 0; --i)
		buf[i + 6] = buf[i];

	buf[0] = 'S';
	buf[1] = 'E';
	buf[2] = 'R';
	buf[3] = 'V';
	buf[4] = ':';
	buf[5] = ' ';
}

int main(int argc, char* argv[]) {
	signal(SIGINT, interrupt);

	server_sock = socket(AF_INET, SOCK_STREAM, 0);
	if (server_sock == -1) {
		printf("ERROR::1 Socket error.\n");
		exit(1);
	}
	printf("Server on.\n");
	printf("Server socket file descriptor: %d\n", server_sock);

	int optval = 1;
	setsockopt(server_sock, SOL_SOCKET, SO_REUSEADDR, (void *)&optval, sizeof(optval));

	struct sockaddr_in server_addr = { 0 };
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	server_addr.sin_port = htons(atoi(PORT));
	socklen_t server_addr_len = sizeof(server_addr);

	if (bind(server_sock, (struct sockaddr *)&server_addr, server_addr_len) == -1) {
		printf("ERROR::2 Bind error.\n");
		exit(1);
	}
	printf("Binding succeeded.\n");

	if (listen(server_sock, 5) == -1) {
		printf("ERROR::3 Listen error.\n");
		exit(1);
	}
	printf("Waiting for a client...\n");

	client_sock = 0;
	struct sockaddr_in client_addr = { 0 };
	socklen_t client_addr_len = sizeof(client_addr);

	while (1) {
		memset(&client_addr, 0, client_addr_len);

		client_sock = accept(server_sock, (struct sockaddr *)&client_addr, &client_addr_len);
		if (client_sock == -1) {
			printf("ERROR::4 Accept error.\n");
			break;
		}
		printf("Client connent success!\n");

		char buf[256];
		while (1) {
			memset(buf, 0, 256);

			int len = read(client_sock, buf, 99);
			removeEnterChar(buf);

			if (len == 0) {
				printf("INFO::Disconnected with client... Bye!\n");
				break;
			}

			if (!strcmp("exit", buf)) {
				printf("INFO::Client has closed... Bye!\n");
				break;
			}
			printf("MESSAGE RECEIVCE: %s\n", buf);
			prefixingMessage(buf);
			printf("MESSAGE SENT:     %s\n", buf);
			
			write(client_sock, buf, strlen(buf));
		}
		close(client_sock);
		printf("Client bye!\n");
	}
	close(server_sock);
	printf("Server off.\n");

	return 0;
}

