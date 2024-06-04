from django.db import models
from django.contrib.auth.models import AbstractUser
from allauth.account.adapter import DefaultAccountAdapter

class User(AbstractUser):
    username = models.CharField(max_length=30, unique=True)
    nickname = models.CharField(max_length=255, blank=True, null=True)
    email = models.EmailField(max_length=254, blank=True, null=True)
    handicap = models.SmallIntegerField(blank=True, null=True)
    # created_at = models.DateTimeField(auto_now_add=True)
    is_resigned = models.BooleanField(default=False)
    resigned_at = models.DateTimeField(blank=True, null=True)
    connected_device = models.IntegerField(blank=True, null=True)
    device_permission = models.BooleanField(default=False)

    USERNAME_FIELD = 'username'

# Create your models here.
# class User(AbstractUser):
#     username = models.CharField(max_length=30, unique=True)
#     nickname = models.CharField(max_length=255, blank=True, null=True)
#     email = models.EmailField(max_length=254, blank=True, null=True)
#     age = models.IntegerField(blank=True, null=True)
#     money = models.IntegerField(blank=True, null=True)
#     salary = models.IntegerField(blank=True, null=True)
#     financial_products = models.TextField(blank=True, null=True)
#     is_active = models.BooleanField(default=True)
#     is_staff = models.BooleanField(default=False)
#     is_superuser = models.BooleanField(default=False)

#     USERNAME_FIELD = 'username'


class CustomAccountAdapter(DefaultAccountAdapter):
    def save_user(self, request, user, form, commit=True):
        """
        Saves a new `User` instance using information provided in the
        signup form.
        """
        from allauth.account.utils import user_email, user_field, user_username
        data = form.cleaned_data
        first_name = data.get("first_name")
        last_name = data.get("last_name")
        email = data.get("email")
        username = data.get("username")
        nickname = data.get("nickname")
        handicap = data.get("handicap")
        is_resigned = data.get("is_resigned")
        resigned_at = data.get("resigned_at")
        connected_device = data.get("connected_device")
        device_permission = data.get('device_permission')
        user_email(user, email)
        if not nickname:
            nickname = username
        user_username(user, username)
        if first_name:
            user_field(user, "first_name", first_name)
        if last_name:
            user_field(user, "last_name", last_name)
        if nickname:
            user_field(user, "nickname", nickname)
        if handicap:
            user.handicap = handicap
        if is_resigned:
            user.is_resigned = is_resigned
        if resigned_at:
            user.resigned_at = resigned_at
        if connected_device:
            user.connected_device = connected_device
        if device_permission:
            user.device_permission = device_permission
        if "password1" in data:
            user.set_password(data["password1"])
        else:
            user.set_unusable_password()
        self.populate_username(request, user)
        if commit:
        # Ability not to commit makes it easier to derive from
        # this adapter by adding
            user.save()
        return user
