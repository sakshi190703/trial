from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth.forms import UserCreationForm, UserChangeForm
from django.utils.html import format_html
from django.urls import reverse
from django.http import HttpResponseRedirect
from django.contrib import messages
from django.utils.translation import gettext_lazy as _

# Register your models here.
from kongo_auth.models import User, UserProfile, UserNotificationsSettings


class CustomUserCreationForm(UserCreationForm):
    """Custom form for creating users in admin with all required fields"""
    
    class Meta:
        model = User
        fields = ('username', 'email')
    
    def save(self, commit=True):
        user = super().save(commit=False)
        user.set_password(self.cleaned_data["password1"])
        user.is_active = True  # Make users active by default
        user.are_guidelines_accepted = True  # Accept guidelines by default
        if commit:
            user.save()
        return user


class CustomUserChangeForm(UserChangeForm):
    """Custom form for editing users in admin"""
    
    class Meta:
        model = User
        fields = '__all__'


class UserProfileInline(admin.StackedInline):
    """Inline profile editing"""
    model = UserProfile
    can_delete = False
    verbose_name_plural = 'Profile'
    
    fields = (
        'name', 'bio', 'location', 'url', 'followers_count_visible',
        'community_posts_visible', 'avatar', 'cover'
    )
    
    def has_delete_permission(self, request, obj=None):
        return False


class UserNotificationsSettingsInline(admin.StackedInline):
    """Inline notification settings"""
    model = UserNotificationsSettings
    can_delete = False
    verbose_name_plural = 'Notification Settings'
    
    def has_delete_permission(self, request, obj=None):
        return False


class UserAdmin(BaseUserAdmin):
    """Enhanced User Admin with mobile app focus"""
    
    form = CustomUserChangeForm
    add_form = CustomUserCreationForm
    
    # List display
    list_display = (
        'username', 'email', 'is_active', 'is_staff', 'date_joined', 'user_actions'
    )
    
    list_filter = (
        'is_active', 'is_staff', 'is_superuser', 
        'date_joined', 'last_login'
    )
    
    search_fields = ('username', 'email')
    
    ordering = ('-date_joined',)
    
    # Fieldsets for editing
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        (_('Personal info'), {
            'fields': ('email',)
        }),
        (_('Permissions'), {
            'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions'),
            'classes': ('collapse',)
        }),
        (_('Important dates'), {
            'fields': ('last_login', 'date_joined'),
            'classes': ('collapse',)
        }),
        (_('Mobile App Info'), {
            'fields': ('uuid', 'language', 'are_guidelines_accepted', 'is_email_verified', 'visibility'),
            'classes': ('collapse',)
        }),
    )
    
    # Fieldsets for adding new users
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'email', 'password1', 'password2'),
        }),
        (_('Permissions'), {
            'fields': ('is_active', 'is_staff'),
            'classes': ('collapse',)
        }),
        (_('Mobile App Settings'), {
            'fields': ('are_guidelines_accepted', 'is_email_verified'),
            'classes': ('collapse',)
        }),
    )
    
    inlines = [UserProfileInline, UserNotificationsSettingsInline]
    
    readonly_fields = ('date_joined', 'last_login', 'uuid', 'visibility')
    
    def user_actions(self, obj):
        """Custom actions for each user"""
        actions = []
        
        # Login as user button
        actions.append(
            f'<a href="/admin/kongo_auth/user/{obj.pk}/login_as/" '
            f'class="button" style="margin:2px;">🔑 Test Login</a>'
        )
        
        # View profile
        if hasattr(obj, 'profile'):
            actions.append(
                f'<a href="/admin/kongo_auth/userprofile/{obj.profile.pk}/change/" '
                f'class="button" style="margin:2px;">👤 View Profile</a>'
            )
        
        return format_html(''.join(actions))
    
    user_actions.short_description = 'Actions'
    user_actions.allow_tags = True
    
    def get_queryset(self, request):
        """Optimize queries"""
        qs = super().get_queryset(request)
        return qs.select_related('profile')
    
    def save_model(self, request, obj, form, change):
        """Custom save logic"""
        super().save_model(request, obj, form, change)
        
        # Create profile if it doesn't exist
        if not hasattr(obj, 'profile'):
            UserProfile.objects.create(user=obj)
            
        # Create notification settings if they don't exist
        if not hasattr(obj, 'notifications_settings'):
            UserNotificationsSettings.objects.create(user=obj)
            
        if not change:  # New user
            messages.success(request, 
                f'User {obj.username} created successfully! '
                f'They can now login to the mobile app with username: {obj.username}'
            )


# Quick action to create test users
class QuickUserCreator(admin.ModelAdmin):
    """Helper admin for quick user creation"""
    
    def changelist_view(self, request, extra_context=None):
        """Custom changelist with quick user creation"""
        if request.method == 'POST' and 'create_test_user' in request.POST:
            # Create a test user
            import random
            username = f"testuser{random.randint(1000, 9999)}"
            email = f"{username}@kootumb.com"
            
            user = User.objects.create_user(
                username=username,
                email=email,
                password='password123',
                first_name='Test',
                last_name='User'
            )
            
            messages.success(request, 
                f'✅ Test user created!\n'
                f'Username: {user.username}\n'
                f'Email: {user.email}\n'
                f'Password: password123'
            )
            
            return HttpResponseRedirect(f'/admin/kongo_auth/user/{user.pk}/change/')
        
        return super().changelist_view(request, extra_context)


# Register our enhanced User admin (handle if already registered)
try:
    admin.site.unregister(User)
except admin.sites.NotRegistered:
    pass
admin.site.register(User, UserAdmin)

# Register other models with better admin
@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'name', 'location', 'followers_count_visible')
    search_fields = ('user__username', 'name', 'location')
    list_filter = ('followers_count_visible', 'community_posts_visible')
    
    fieldsets = (
        (_('Basic Info'), {
            'fields': ('user', 'name', 'bio', 'location', 'url')
        }),
        (_('Privacy Settings'), {
            'fields': ('followers_count_visible', 'community_posts_visible'),
            'classes': ('collapse',)
        }),
        (_('Media'), {
            'fields': ('avatar', 'cover'),
            'classes': ('collapse',)
        }),
    )


@admin.register(UserNotificationsSettings)
class UserNotificationsSettingsAdmin(admin.ModelAdmin):
    list_display = ('user', 'post_comment_notifications', 'follow_notifications')
    search_fields = ('user__username',)
    list_filter = (
        'post_comment_notifications', 'follow_notifications', 
        'connection_request_notifications'
    )


# Customize admin site headers
admin.site.site_header = "Kootumb Social Media Admin"
admin.site.site_title = "Kootumb Admin Portal"
admin.site.index_title = "Welcome to Kootumb Administration"
