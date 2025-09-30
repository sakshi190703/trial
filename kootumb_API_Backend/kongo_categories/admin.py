from django.contrib import admin

from kongo_categories.models import Category


class CategoryAdmin(admin.ModelAdmin):
    search_fields = ('name',)
    exclude = ['communities']


admin.site.register(Category, CategoryAdmin)
