"""
WSGI config for A202 project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/howto/deployment/wsgi/
"""

import os
import threading
import socketfile

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'A202.settings')

application = get_wsgi_application()

def run_socket_server():
    socketfile.start_server()

socket_thread = threading.Thread(target=run_socket_server)
socket_thread.daemon = True
socket_thread.start()
