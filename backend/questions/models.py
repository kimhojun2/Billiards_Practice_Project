from django.db import models
from django.conf import settings
from balls.models import location, route
# Create your models here.

class Question(models.Model):
    user_seq = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE
    )
    location_seq = models.ForeignKey(
        location, on_delete=models.CASCADE
    )
    title = models.CharField(max_length=100)
    content = models.CharField(max_length=8000)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_deleted = models.BooleanField(default=False)


class Answer(models.Model):
    user_seq = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE
    )
    route_seq = models.ForeignKey(route, on_delete=models.CASCADE)
    question_seq = models.ForeignKey(Question, on_delete=models.CASCADE, related_name='answers')
    content = models.CharField(max_length=3000)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_deleted = models.BooleanField(default=False)
    difficulty = models.IntegerField(null=True)
