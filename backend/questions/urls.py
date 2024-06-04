from django.urls import path
from . import views

urlpatterns = [
    path('', views.questionlist),
    path('create/<int:route_pk>/', views.question_create),
    path('question/<int:question_pk>/', views.question_detail),
    path('answers/<int:question_seq>/', views.answer_create),
    # path('question/<int:question_pk>/answer/', views.answer_create),
]