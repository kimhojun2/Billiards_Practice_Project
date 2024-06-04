from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from django.shortcuts import get_list_or_404, get_object_or_404
from .models import location, route
from accounts.models import User
from .serializers import LocationSerializer, RouteSerializer, HistorySerializer
from django.http import JsonResponse 
from django.contrib.auth.decorators import login_required, permission_required
from rest_framework.decorators import permission_classes
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated

from A202.settings import message_queue

# 공 좌표 정보
@api_view(['GET'])
@permission_classes([IsAuthenticatedOrReadOnly])
def ball_location(request, loca_seq):
    loca = get_object_or_404(location, pk=loca_seq)
    serializer = LocationSerializer(loca)
    print(serializer.data)
    return Response(serializer.data)


# 퀴즈 공 좌표 정보
@api_view(['GET'])
@permission_classes([IsAuthenticatedOrReadOnly])
def quizball(request, quiz_num):
    quiz_data = get_list_or_404(location, is_quiz=1)
    quiz = quiz_data[quiz_num]
    serializer = LocationSerializer(quiz)
    return Response(serializer.data)


# 퀴즈 정답 정보
@api_view(['GET'])
@permission_classes([IsAuthenticatedOrReadOnly])
def quiz_answer(request, quiz_num):
    quiz_data = get_list_or_404(location, is_quiz=1)

    if 0 <= quiz_num < len(quiz_data):
        target = quiz_data[quiz_num]
        print(target.id)
        quiz_answer_data = get_list_or_404(route, loca_seq=target)[0]
        print(quiz_answer_data)
        serializer = RouteSerializer(quiz_answer_data)
        return Response(serializer.data)
    
    else:
        return Response({'message': 'No Quiz'}, status=404)



@api_view(['GET'])
@permission_classes([IsAuthenticatedOrReadOnly])
def ball_route(request, route_pk):
    ball_route_data = get_object_or_404(route, pk=route_pk)
    serializer = RouteSerializer(ball_route_data)
    return Response(serializer.data)


# 내가 친 경로 
@api_view(['GET'])
# @permission_classes([IsAuthenticated]) # -----> 수정함
def my_history_route(request, username):
    user = get_object_or_404(User, username=username)
    user_id = user.pk
    # histry_data = get_list_or_404(route, user_seq=user_id)
    histry_data = route.objects.filter(user_seq=user_id).order_by('-created_at')[:4]
    serializer = HistorySerializer(histry_data, many=True)
    return Response(serializer.data)


@api_view(['POST'])
@permission_classes([IsAuthenticatedOrReadOnly])    # 수정내용
def ball_to_device(request):
    send_seq = f'{request.user.connected_device}'
    if 'sign' in request.data:
        sign_data = request.data['sign']
        if sign_data == '0':
            print('녹화 시작')
            message = send_seq+'{"device_info":111111,"unix_time":"","num_of_frames":0,"sampling_rate":60.0,"billiard_info":{"board_y":60.0,"board_x":120.0,"ball_diameter":5.6},"positions":{"white":[],"yellow":[],"red":[]}}'
            print(message)
            message_queue.put(message)
            return JsonResponse({"message": "Received sign data successfully."})
        else:
            print('사용 종료')
            message = send_seq+'{"device_info":111111,"unix_time":"","num_of_frames":-1,"sampling_rate":60.0,"billiard_info":{"board_y":60.0,"board_x":120.0,"ball_diameter":5.6},"positions":{"white":[],"yellow":[],"red":[]}}'
            message_queue.put(message)
            return JsonResponse({"message": "Received sign data successfully."})
    elif 'route_seq' in request.data:
        print(f'기기에 경로 다시보기 좌표 전송')
        seq = int(request.data['route_seq'])
        print(seq)
        route_info = get_object_or_404(route, pk=seq)
        print(route_info)
        json_data = f'{route_info.route_file}'
        print(json_data)
        send_data = json_data.replace("'", '"')
        print(send_data)
        print(f'{request.user.connected_device}{send_data}')
        message_queue.put(f'{request.user.connected_device}{send_data}')
        return JsonResponse({"message": "Received route_seq successfully."})
    elif 'loca_seq' in request.data:
        print('기기에 공 좌표 전송')
        seq = int(request.data['loca_seq'])
        loca_info = get_object_or_404(location, pk=seq)
        json_data = f'{loca_info.loca_file}'
        send_data = json_data.replace("'", '"')
        print(f'{request.user.connected_device}{send_data}')
        message_queue.put(f'{request.user.connected_device}{send_data}')
        return JsonResponse({"message": "Received ball_seq successfully."})
    
