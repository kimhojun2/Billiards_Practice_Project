from rest_framework import serializers
from .models import location, route
from accounts.models import User

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = location
        fields = '__all__'


class RouteSerializer(serializers.ModelSerializer):
    class Meta:
        model = route
        fields = '__all__'


class HistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = route
        fields = '__all__'