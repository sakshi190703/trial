from django.utils.timezone import get_current_timezone
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from django.utils import timezone
from django.utils.translation import gettext_lazy as _
from rest_framework.permissions import AllowAny


from kongo_common.checkers import check_url_can_be_proxied
from kongo_common.serializers import CommonEmojiGroupSerializer, \
    ProxyDomainCheckSerializer
from kongo_common.utils.model_loaders import get_emoji_group_model


class Time(APIView):
    """
    API for returning the current time.
    """

    def get(self, request):
        time = timezone.localtime(timezone.now())
        time_zone = get_current_timezone()

        return Response({
            'time': time,
            'timezone': str(time_zone)
        }, status=status.HTTP_200_OK)


class Health(APIView):
    """
    API for checking the app health
    """

    def get(self, request):
        return Response({
            'message': 'Todo muy bueno!'
        })


class EmojiGroups(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        EmojiGroup = get_emoji_group_model()
        emoji_groups = EmojiGroup.objects.filter(is_reaction_group=False).all().order_by('order')
        serializer = CommonEmojiGroupSerializer(emoji_groups, many=True, context={'request': request})

        return Response(serializer.data, status=status.HTTP_200_OK)


class ProxyDomainCheck(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        query_params = request.query_params.dict()
        serializer = ProxyDomainCheckSerializer(data=query_params)
        serializer.is_valid(raise_exception=True)

        data = serializer.validated_data
        url = data.get('url')

        check_url_can_be_proxied(url)

        return Response(_('Domain is okay to be proxied'), status=status.HTTP_202_ACCEPTED)
    
class ChildSafetyPolicyView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        return Response({
            "policy": "We are committed to ensuring the safety and well-being of children using our services. ..."
        })
# class GuidelinesView(APIView):
#     permission_classes = [AllowAny]

#     def get(self, request):
#         # Replace with your actual guidelines content or fetch from DB
#         return Response({"guidelines": "Your guidelines text goes here."})
