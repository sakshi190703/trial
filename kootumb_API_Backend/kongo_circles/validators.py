from rest_framework.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _

from kongo_circles.models import Circle


def circle_id_exists(circle_id):
    count = Circle.objects.filter(id=circle_id).count()

    if count == 0:
        raise ValidationError(
            _('The circle does not exist.'),
        )
