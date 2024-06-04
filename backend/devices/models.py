from django.db import models

class Device(models.Model):
    serial_num = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)
    created_at = models.DateTimeField(auto_now=True)
    is_dumped = models.BooleanField(default=False)
    dumpde_at = models.DateTimeField(null=True)
