from rest_framework import serializers
from .models import Question, Answer
from accounts.models import User


class QuestionListSerializer(serializers.ModelSerializer):
    username = serializers.ReadOnlyField(source='user_seq.username')
    nickname = serializers.ReadOnlyField(source='user_seq.nickname')
    class Meta:
        model = Question
        fields = ('id', 'user_seq', 'username', 'nickname', 'title', 'content', 'created_at', 'location_seq')



class AnswerSerializer(serializers.ModelSerializer):
    username = serializers.ReadOnlyField(source='user_seq.username')
    nickname = serializers.ReadOnlyField(source='user_seq.nickname')
    class Meta:
        model = Answer
        fields = '__all__'
        read_only_fields = ('user_seq', 'question_seq', 'route_seq_id', 'username','nickname')


class QuestinoSerializer(serializers.ModelSerializer):
    answers = AnswerSerializer(many=True, read_only=True, source='answers.all')
    username = serializers.ReadOnlyField(source='user_seq.username')
    nickname = serializers.ReadOnlyField(source='user_seq.nickname')
    class Meta:
        model = Question
        fields = '__all__'
        read_only_fields = ('user_seq','location_seq','username','nickname')

