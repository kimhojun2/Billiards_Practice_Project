import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'A202.settings')
django.setup()

import copy
import socket
import threading
import json
from A202.settings import message_queue
from balls.models import location, route
from balls.serializers import LocationSerializer, RouteSerializer
from devices.models import Device
from django.shortcuts import get_list_or_404, get_object_or_404
from accounts.models import User
#{"device_info":1,"unix_time":"","num_of_frames":1,"sampling_rate":60.0,"billiard_info":{"board_y":60.0,"board_x":120.0,"ball_diameter":5.6},"positions":{"white":[[0,0]],"yellow":[[15,15]],"red":[[50,10]]}}



Device_List = list(Device.objects.values_list('serial_num', flat=True))
Device_dict = {serial_num: None for serial_num in Device_List}
client_sockets = []  
sockets = {}
clients = {}

def handle_client(client_sock, client_addr, client_sockets):
    try:
        while True:
            # print(message_queue)
            data = client_sock.recv(1024)
            if data == b'exit':
                break
            received_data = data.decode("utf-8")
            json_info = json.loads(received_data)


            try:
                device_info = json_info["device_info"]
                num_of_frames_info = json_info["num_of_frames"]

                if num_of_frames_info == 1:
                    print('공 좌표')
                    if device_info in Device_List:
                        location_instance = location(loca_file=json_info, is_quiz=False)
                        location_instance.save()
                        client_sock.sendall('Location success!!'.encode())
                    else:
                        print('문제 있는 좌표 데이터')
            
                else:
                    print('경로 좌표')
                    if device_info in Device_List:
                        now_device = get_object_or_404(Device, serial_num=int(device_info))
                        now_user = get_object_or_404(User, connected_device=now_device.serial_num)
                        positions = json_info.get('positions')
                        white = positions.get('white')[0]
                        yellow = positions.get('yellow')[0]
                        red = positions.get('red')[0]
                        new_json_info = copy.deepcopy(json_info)
                        new_json_info['positions']['white'] = [white]
                        new_json_info['positions']['red'] = [red]
                        new_json_info['positions']['yellow'] = [yellow]
                        new_json_info['num_of_frames'] = 1
                        location_instance = location(loca_file=new_json_info, is_quiz=False)
                        location_instance.save()
                        route_instance = route(route_file=json_info, device_seq=now_device, user_seq=now_user, loca_seq=location_instance)
                        route_instance.save()

                        client_sock.sendall('Route success!!'.encode())
            except KeyError:
                print('에러')
                continue

            

    except Exception as e:
        print(f'Error handling client {client_addr}: {e}')

    finally:
        client_sockets.remove(client_sock)
        clients[f'{client_sock}'] = None
        client_sock.close()
        print(f'Connection with {client_addr} closed.')


def start_server():
    print(Device_List)
    server_host = '0.0.0.0'
    server_port = 55555

    server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_sock.bind((server_host, server_port))
    server_sock.listen(5)
    
    print(f'Server is listening on {server_host}:{server_port}')

    try:
        
        send_thread = threading.Thread(target=handle_user_input, args=(client_sockets,))
        send_thread.start()

        connect_thread = threading.Thread(target=wait_for_clients, args=(server_sock, client_sockets ))
        connect_thread.start()
 



    except KeyboardInterrupt:
        print('Server is shutting down...')
        server_sock.close()

def handle_user_input(client_sockets):
   
    while True:
        message = message_queue.get()
        if message.lower() == 'exit':
            break
        target_client_index = Device_List.index(int(message[:6]))
        # print(client_sock.getpeername()[1])
        if 0 <= target_client_index < len(client_sockets):
            target_client_socket = client_sockets[target_client_index]
            target_client_socket.sendall(message[6:].encode('utf-8'))
        else:
            print(f'Invalid client index: {target_client_index}')


def wait_for_clients(server_sock, client_sockets):
    print('시작')
    while True:
        client_sock, client_addr = server_sock.accept()
        print(f'Accepted connection from {client_addr}')
        client_sockets.append(client_sock)
        clients[client_sock.getpeername()[1]] = client_sock
        
        # print(client_sockets)
        new_client_thread = threading.Thread(target=handle_client, args=(client_sock, client_addr, client_sockets))
        new_client_thread.start()
