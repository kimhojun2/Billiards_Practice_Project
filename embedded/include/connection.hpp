#pragma once

#include <arpa/inet.h>
#include <atomic>
#include <condition_variable>
#include <mutex>
#include <netinet/in.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#include <jsoncpp/json/json.h>

#include "dobilliard.hpp"

namespace conn {

	class Sock {
	private:
		std::atomic<bool> f_connected;
		const char* const server_ip;
		const char* const server_port;
		int client_sock;
		bool f_run;
		int retry_interval = 5;
		bill::Message& msg_recv;
		bill::Message& msg_send;
		std::mutex& mut_msg_recv;
		std::mutex& mut_msg_send;
		std::condition_variable& cv_itrp;
		std::condition_variable& cv_send;
		std::thread t_mnge;
		std::thread t_recv;
		std::thread t_send;
		pthread_t th_mnge;
		pthread_t th_recv;
		pthread_t th_send;

		static bool mtos(const bill::Message& msg, std::string& str) {
			LOG("[ INFO ] Start packing data into json format.");

			Json::Value msgval;

			try {
				msg >> msgval;
			}
			catch (Json::Exception& e) {
				LOG("[ WARN ] Error occured while constructing server message. " << e.what());
				return false;
			}

			str = msgval.asString();

			return true;
		}

		static bool stom(const std::string& str, bill::Message& msg) {
			LOG("[ INFO ] Start parsing server message.");

			Json::Value json;
			Json::Reader reader;
			if (!reader.parse(str, json, false)) {
				LOG("[ WARN ] JSON parsing error.");
				return false;
			}

			try {
				msg << json;
			}
			catch (Json::Exception& e) {
				LOG("[ WARN ] Error occured while parsing server message. " << e.what());
				return false;
			}

			return true;
		}

		void send() {
			LOG("[ INFO ] Socket sender started.");
			while (this->f_connected) {
				LOG("[ INFO ] Waiting for socket send request.");

				{
					std::unique_lock<std::mutex> ul(this->mut_msg_send);
					this->cv_send.wait(ul, [&]() { return this->msg_send.valid || !this->f_connected; });

					if (!this->f_connected) {
						LOG("[ WARN ] Server disconnected. Terminating socket sender.");
						continue;
					}

					if (this->msg_send.valid) {
						LOG("[ INFO ] Message send request accepted. Start packing message.");
					}

					std::string msgstr;
					if (!Sock::mtos(this->msg_send, msgstr)) {
						LOG("[ WARN ] Message discarded.");
						continue;
					}

					int len = msgstr.size();

					write(this->client_sock, msgstr.c_str(), len);
					LOG("[ INFO ] Message sent: " << msgstr);
				}
			}
		}

		void receive() {
			LOG("[ INFO ] Socket receiver started.");
			while (this->f_connected) {
				LOG("[ INFO ] Waiting for server message.");

				char buf[8192];
				memset(buf, 0, 8192);
				int len = read(this->client_sock, buf, 8191);
				if (!len) {
					LOG("[ WARN ] Server disconnected. Notifying sender and terminating receiver.");
					this->f_connected = false;
					this->cv_send.notify_all();
					continue;
				}

				LOG("[ INFO ] Server message: " << buf);

				{
					std::unique_lock<std::mutex> ul(this->mut_msg_recv);
					LOG("[ DEBUG ] RECV MSG mutex locked.");

					LOG("[ INFO ] Start parsing server message.");
					if (!Sock::stom(std::string(buf), this->msg_recv)) {
						LOG("[ WARN ] Error occured while parsing server message. Received message ignored.");
						continue;
					}

					this->msg_recv.valid = true;
				}

				LOG("[ DEBUG ] Notifying server message to other threads.");
				this->cv_itrp.notify_all();
			}

			return;
		}

		bool initSocketConnection() {
			LOG("[ INFO ] Start initializing socket connection.");
			this->client_sock = socket(AF_INET, SOCK_STREAM, 0);
			if (this->client_sock == -1) {
				LOG("[ WARN ] Client socket creation failed.");
				return false;
			}
			LOG("[ INFO ] Client socket created.");

			struct sockaddr_in server_addr = {0};
			server_addr.sin_family = AF_INET;
			server_addr.sin_addr.s_addr = inet_addr(this->server_ip);
			server_addr.sin_port = htons(atoi(this->server_port));
			socklen_t server_addr_len = sizeof(server_addr);

			if (connect(this->client_sock, (struct sockaddr*)&server_addr, server_addr_len) == -1) {
				LOG("[ WARN ] Server connection failed.");
				return false;
			}
			LOG("[ INFO ] Server connection success.");

			return true;
		}

		void manage() {
			LOG("[ INFO ] Starting connection manager.");
			while (this->f_run) {
				LOG("[ INFO ] Calling socket initializer.");
				this->f_connected = this->initSocketConnection();
				if (!this->f_connected) {
					while (true) {
						LOG("[ WARN ] Failed to initialize socket connection.");
						LOG("[ WARN ] Retrying socket connection in " << this->retry_interval << " seconds.");
						std::this_thread::sleep_for(std::chrono::seconds(this->retry_interval));
						this->f_connected = this->initSocketConnection();
						if (this->f_connected) break;
					}
				}

				this->t_recv = std::thread(&Sock::receive, this);
				this->t_send = std::thread(&Sock::send, this);
				LOG("[ INFO ] Socket receiver and sender created.");

				this->th_recv = t_recv.native_handle();
				this->th_send = t_send.native_handle();

				t_recv.join();
				t_send.join();

				LOG("[ WARN ] Server disconnected.");
			}
			LOG("[ INFO ] Terminating connection mananger.");
		}

	public:
		Sock(
		    const char* const server_ip,
		    const char* const server_port,
		    bill::Message& msg_recv,
		    bill::Message& msg_send,
		    std::mutex& mut_msg_recv,
		    std::mutex& mut_msg_send,
		    std::condition_variable& cv_itrp,
		    std::condition_variable& cv_send,
		    int retry_interval = 5) : server_ip(server_ip),
		                              server_port(server_port),
		                              retry_interval(retry_interval),
		                              msg_recv(msg_recv),
		                              msg_send(msg_send),
		                              mut_msg_recv(mut_msg_recv),
		                              mut_msg_send(mut_msg_send),
		                              cv_itrp(cv_itrp),
		                              cv_send(cv_send) {
			this->f_connected = false;
			this->f_run = true;

			LOG("[ INFO ] Creating connection manager on new thread.");
			this->t_mnge = std::thread(&Sock::manage, this);
			this->th_mnge = t_mnge.native_handle();

			LOG("[ INFO ] Detaching connection manager.");
			this->t_mnge.detach();
		}

		~Sock() {
			pthread_cancel(this->th_mnge);
			pthread_cancel(this->th_recv);
			pthread_cancel(this->th_send);

			if (this->t_mnge.joinable()) this->t_mnge.join();
			if (this->t_recv.joinable()) this->t_recv.join();
			if (this->t_send.joinable()) this->t_send.join();
		}
	};
}