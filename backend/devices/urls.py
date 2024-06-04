from django.urls import path, include
from . import views


urlpatterns = [
    path('<int:device_seq>/history/', views.device_history_routes),
    path('check/', views.device_check),
    # path('<int:device_seq>/history/', views.device_history_routes),
]
