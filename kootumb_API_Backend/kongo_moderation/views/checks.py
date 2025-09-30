from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView

from kongo_moderation.permissions import IsNotSuspended
from kongo_common.responses import ApiMessageResponse
from django.utils.translation import gettext_lazy as _


class IsNotSuspendedCheck(APIView):
    permission_classes = (IsAuthenticated, IsNotSuspended,)

    def get(self, request):
        return ApiMessageResponse(message=_('Congrats, you\'re not suspended :-)'), status=status.HTTP_200_OK)
