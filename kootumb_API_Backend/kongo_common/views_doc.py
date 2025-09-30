from django.http import JsonResponse
from django.views import View

class APIDocumentationView(View):
    def get(self, request):
        api_endpoints = {
            "message": "Welcome to Kootumb API Backend!",
            "version": "2.2.16",
            "status": "running",
            "available_endpoints": {
                "health": "/health/",
                "admin": "/admin/",
                "api_base": "/api/",
                "authentication": {
                    "register": "/api/auth/register/",
                    "login": "/api/auth/login/",
                    "username_check": "/api/auth/username-check/",
                    "email_check": "/api/auth/email-check/",
                    "email_verify": "/api/auth/email/verify/",
                    "password_reset": "/api/auth/password/reset/",
                    "password_verify": "/api/auth/password/verify/"
                },
                "user_management": {
                    "authenticated_user": "/api/auth/user/",
                    "user_settings": "/api/auth/user/settings/",
                    "search_users": "/api/auth/users/",
                    "blocked_users": "/api/auth/blocked-users/",
                    "followers": "/api/auth/followers/",
                    "following": "/api/auth/following/"
                },
                "content": {
                    "posts": "/api/posts/",
                    "communities": "/api/communities/",
                    "categories": "/api/categories/",
                    "hashtags": "/api/hashtags/",
                    "notifications": "/api/notifications/"
                },
                "social": {
                    "circles": "/api/circles/",
                    "connections": "/api/connections/",
                    "follows": "/api/follows/",
                    "lists": "/api/lists/"
                },
                "utilities": {
                    "time": "/api/time/",
                    "emoji_groups": "/api/emojis/groups/",
                    "proxy_domain_check": "/api/proxy-domain-check/"
                }
            },
            "authentication_note": "Most endpoints require authentication. Use /api/auth/login/ to get an authentication token.",
            "testing_endpoints": [
                "/health/ - Public health check",
                "/api/time/ - Public time endpoint",
                "/api/auth/register/ - User registration",
                "/api/auth/login/ - User login"
            ]
        }
        return JsonResponse(api_endpoints, json_dumps_params={'indent': 2})
