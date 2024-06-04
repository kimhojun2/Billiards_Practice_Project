from django.db import models
from django.conf import settings
from devices.models import Device

class Userlog(models.Model):
    device_seq = models.ForeignKey(Device, on_delete=models.CASCADE)
    user_seq = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    start_at = models.DateTimeField()
    quit_at = models.DateField()
