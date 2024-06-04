import socket
import threading

def send_message(client_socket):
    try:
        while True:
            message = input(">>> ")
            client_socket.sendall(message.encode('utf-8'))
            if message.lower() == 'exit':
                break

    except Exception as e:
        print(f'Error sending message: {e}')

    finally:
        client_socket.close()

def receive_message(client_socket):
    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break
            print(f'Server: {data.decode()}')

    except Exception as e:
        print(f'Error receiving message: {e}')

    finally:
        client_socket.close()

def start_client():
    server_host = '3.35.141.26'
    # server_host = 'localhost'
    server_port = 55555

    client_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_sock.bind(('0.0.0.0', 50001))
    client_sock.connect((server_host, server_port))

    # 서버로부터 메시지를 받는 스레드
    recv_thread = threading.Thread(target=receive_message, args=(client_sock,))
    recv_thread.start()

    # 사용자 입력을 서버로 전송하는 스레드
    send_thread = threading.Thread(target=send_message, args=(client_sock,))
    send_thread.start()

    send_thread.join()
    recv_thread.join()

if __name__ == "__main__":
    start_client()
