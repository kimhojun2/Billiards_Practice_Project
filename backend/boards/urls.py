from django.urls import path, include
from . import views

urlpatterns = [
    path('boardlist/', views.boardlist),
    path('boardlist/<int:board_pk>/', views.board_detail),
    path('comments/<int:comment_pk>/', views.comment_detail),
    path('board/<int:board_pk>/comment/', views.comment_create),
]