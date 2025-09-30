from django.conf import settings
from rest_framework import serializers

from kongo_auth.models import User, UserProfile
from kongo_common.models import Badge
from kongo_common.serializers_fields.user import \
    IsFollowingField, IsConnectedField


class GetFollowingsSerializer(serializers.Serializer):
    max_id = serializers.IntegerField(
        required=False,
    )
    count = serializers.IntegerField(
        required=False,
        max_value=20
    )


class SearchFollowingsSerializer(serializers.Serializer):
    query = serializers.CharField(max_length=settings.SEARCH_QUERIES_MAX_LENGTH, required=True)
    count = serializers.IntegerField(
        required=False,
        max_value=20
    )


class FollowingsUserProfileBadgeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Badge
        fields = (
            'keyword',
            'keyword_description'
        )


class FollowingsUserProfileSerializer(serializers.ModelSerializer):
    badges = FollowingsUserProfileBadgeSerializer(many=True)

    class Meta:
        model = UserProfile
        fields = (
            'id',
            'avatar',
            'name',
            'badges'
        )


class FollowingsUserSerializer(serializers.ModelSerializer):
    profile = FollowingsUserProfileSerializer(many=False)
    is_following = IsFollowingField()
    is_connected = IsConnectedField()

    class Meta:
        model = User
        fields = (
            'id',
            'profile',
            'username',
            'is_following',
            'is_connected'
        )
