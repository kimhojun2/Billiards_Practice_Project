from django.db import models
from django.conf import settings
from devices.models import Device

class location(models.Model):
    loca_file = models.JSONField()
    created_at = models.DateTimeField(auto_now_add=True)
    is_quiz = models.BooleanField(default=False)


class route(models.Model):
    route_file = models.JSONField()
    created_at = models.DateTimeField(auto_now_add=True)
    loca_seq = models.ForeignKey(location, on_delete=models.CASCADE)
    user_seq = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE
    )
    device_seq = models.ForeignKey(Device, on_delete=models.CASCADE)