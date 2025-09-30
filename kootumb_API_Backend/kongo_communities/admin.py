from django.contrib import admin

from kongo_communities.models import Community


class CommunityAdmin(admin.ModelAdmin):
    def has_add_permission(self, request, obj=None):
        return False


admin.site.register(Community, CommunityAdmin)
