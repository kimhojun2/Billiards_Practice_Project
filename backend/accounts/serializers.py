from rest_framework import serializers
from allauth.account import app_settings as allauth_settings
from allauth.utils import get_username_max_length
from allauth.account.adapter import get_adapter
from .models import User
from dj_rest_auth.registration.serializers import RegisterSerializer


class CustomRegisterSerializer(RegisterSerializer):

    nickname = serializers.CharField(
    required=False,
    allow_blank=True,
    max_length=255
    )
    handicap = serializers.IntegerField(required=False)
    email = serializers.EmailField(max_length=254, required=False, allow_blank=True)
    # is_resigned = serializers.BooleanField(default=False)
    # resigned_at = serializers.DateTimeField(required=False)
    # connected_device = serializers.IntegerField(required=False)
    # device_permission = serializers.BooleanField(default=False)

    def get_cleaned_data(self):
        return {
            'username': self.validated_data.get('username', ''),
            'password1': self.validated_data.get('password1', ''),
            'nickname': self.validated_data.get('nickname', ''),
            'email': self.validated_data.get('email', ''),
            'is_resigned': self.validated_data.get('is_resigned', ''),
            'connected_device': self.validated_data.get('connected_device', ''),
            'handicap': self.validated_data.get('handicap', ''),
            'device_permission': self.validated_data.get('device_permission', ''),
        }
    
    def save(self, request):
        adapter = get_adapter()
        user = adapter.new_user(request)
        self.cleaned_data = self.get_cleaned_data()
        adapter.save_user(request, user, self)
        self.custom_signup(request, user)
        return user
    

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'nickname', 'handicap']