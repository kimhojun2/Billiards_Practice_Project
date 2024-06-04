from django.shortcuts import render
from rest_framework.response import Response
from .models import User
from userlogs.models import Userlog
from django.shortcuts import get_list_or_404, get_object_or_404
from .serializers import CustomRegisterSerializer, ProfileSerializer
from rest_framework.permissions import IsAuthenticated, IsAuthenticatedOrReadOnly
from rest_framework.decorators import permission_classes
from django.utils import timezone
from rest_framework.decorators import api_view
from rest_framework.authtoken.models import Token
from django.contrib.sessions.models import Session
from dj_rest_auth.views import LoginView
from dj_rest_auth.views import LogoutView
# Create your views here.

class customlogin(LoginView):
    def post(self, request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)
        user = self.request.user
        response.data['user_seq'] = user.pk
        response.data['username'] = user.username
        now_user = get_object_or_404(User, username=request.data['username'])
        device_seq = request.data.get('device_seq')
        if device_seq:
            now_user.connected_device = device_seq
            now_user.save()
            return response
        else:
            return response
        


class CustomLogoutView(LogoutView):
    def dispatch(self, request, *args, **kwargs):
        now_user = get_object_or_404(User, username=request.POST['username'])
        try:
            token = Token.objects.get(user=now_user)
            token.delete()
        except Token.DoesNotExist:
            pass
        now_user.connected_device = None
        now_user.save()
        return super().dispatch(request, *args, **kwargs)


def resign(request):
    user = get_object_or_404(User, username=request.user)
    token = Token.objects.get(user=request.user)
    token.delete() 
    user.is_active = False
    user.resigned_at = timezone.now()
    user.save()
    print(user.is_resigned)
    return Response({'hi':'ho'})


@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticatedOrReadOnly])
def profile(request, username):
    print('프로필 views함수는 작동')
    if request.method == 'GET':
        user_profile = get_object_or_404(User, username=username)
        serializer = CustomRegisterSerializer(user_profile)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        user_profile = get_object_or_404(User, username=username)
        serializer = ProfileSerializer(user_profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)



