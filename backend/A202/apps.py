# from django.apps import AppConfig
# import threading


# class SocketConfig(AppConfig):
#     name = 'A202'

#     def ready(self):
#         if not hasattr(self, 'already_run'):
#             self.already_run = True
#             import socketfile
#             socket_thread = threading.Thread(target=socketfile.start_server)
#             socket_thread.daemon = True
#             socket_thread.start()

