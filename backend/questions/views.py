from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from django.shortcuts import get_list_or_404, get_object_or_404
from .models import Question, Answer
from .serializers import QuestionListSerializer, QuestinoSerializer, AnswerSerializer
from balls.serializers import RouteSerializer, LocationSerializer
from balls.models import location, route
from django.contrib.auth.decorators import login_required, permission_required
from rest_framework.decorators import permission_classes
from rest_framework.permissions import IsAuthenticated, IsAuthenticatedOrReadOnly
from rest_framework.views import APIView


@api_view(['GET'])
@permission_classes([IsAuthenticatedOrReadOnly])
def questionlist(request):
    if request.method == 'GET':
        questions = Question.objects.filter(is_deleted=False)
        serializer = QuestionListSerializer(questions, many=True)
        return Response(serializer.data)
    

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def question_create(request, route_pk): # route_pk   
    if request.method == 'POST':
        ball_route = get_object_or_404(route, pk=route_pk)
        ball_loca = ball_route.loca_seq
        serializer = QuestinoSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save(user_seq=request.user, location_seq=ball_loca)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            print(serializer.errors)
        

@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticatedOrReadOnly])
def question_detail(request, question_pk):
    question = get_object_or_404(Question, pk=question_pk)
    if request.method == 'GET':
        serializer = QuestinoSerializer(question)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        if request.user.id == question.user_seq_id:
            serializer = QuestinoSerializer(question, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            else:
                print('형식 고쳐와')
        else:
            print('[PUT]너가 쓴글 아니야')
    
    elif request.method == 'DELETE':
        if request.user.id == question.user_seq_id:
            question.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        else:
            print('[DELETE]너가 쓴글 아니야')
    

@api_view(['POST'])
def answer_create(request, question_seq):
    question = get_object_or_404(Question, pk=question_seq)
    serializer = AnswerSerializer(data=request.data)
    if serializer.is_valid(raise_exception=True):
        serializer.save(question_seq=question, user_seq=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
