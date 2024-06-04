from rest_framework import serializers
from .models import Board, Comment
from accounts.models import User


class BoardListSerializer(serializers.ModelSerializer):
    username = serializers.ReadOnlyField(source='user_seq.username')
    nickname = serializers.ReadOnlyField(source='user_seq.nickname')
    class Meta:
        model = Board
        fields = ('id', 'user_seq', 'username', 'nickname', 'title', 'content', 'created_at')


class CommentSerializer(serializers.ModelSerializer):
    username = serializers.ReadOnlyField(source='user_seq.username')
    nickname = serializers.ReadOnlyField(source='user_seq.nickname')
    class Meta:
        model = Comment
        fields = '__all__'
        read_only_fields = ('user_seq', 'board_seq','username','nickname')


class BoardSerializer(serializers.ModelSerializer):
    comments = CommentSerializer(many=True, read_only=True, source='comments.all')
    username = serializers.ReadOnlyField(source='user_seq.username')
    nickname = serializers.ReadOnlyField(source='user_seq.nickname')
    class Meta:
        model = Board
        fields = '__all__'
        read_only_fields = ('user_seq','username', 'nickname')

