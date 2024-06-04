from django.urls import path
from . import views

urlpatterns = [
    path('quiz/<int:quiz_num>/', views.quizball),
    path('quiz_ans/<int:quiz_num>/', views.quiz_answer),
    path('location/<int:loca_seq>/', views.ball_location),
    path('connection/', views.ball_to_device),
    path('ballroute/<int:route_pk>', views.ball_route),
    path('myhistory/<str:username>/', views.my_history_route),
]