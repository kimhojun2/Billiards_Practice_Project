from django.urls import path, include
from . import views
from balls.views import my_history_route

urlpatterns = [
    path('resign/', views.resign),
    path('profile/<str:username>/', views.profile),
    path('myhistory/<str:username>/', my_history_route),
]