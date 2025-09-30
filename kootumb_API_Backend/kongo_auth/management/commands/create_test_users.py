from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from kongo_auth.models import UserProfile, UserNotificationsSettings
import random

User = get_user_model()


class Command(BaseCommand):
    help = 'Create test users for mobile app testing'

    def add_arguments(self, parser):
        parser.add_argument(
            '--count',
            type=int,
            default=1,
            help='Number of test users to create',
        )
        parser.add_argument(
            '--username',
            type=str,
            help='Specific username for the user',
        )
        parser.add_argument(
            '--password',
            type=str,
            default='password123',
            help='Password for the user (default: password123)',
        )

    def handle(self, *args, **options):
        count = options['count']
        password = options['password']
        
        if options['username']:
            # Create specific user
            username = options['username']
            if User.objects.filter(username=username).exists():
                self.stdout.write(
                    self.style.ERROR(f'User {username} already exists!')
                )
                return
                
            user = self.create_user(username, password)
            self.print_user_info(user, password)
        else:
            # Create multiple test users
            created_users = []
            for i in range(count):
                username = f"testuser{random.randint(1000, 9999)}"
                
                # Ensure username is unique
                while User.objects.filter(username=username).exists():
                    username = f"testuser{random.randint(1000, 9999)}"
                
                user = self.create_user(username, password)
                created_users.append(user)
            
            self.stdout.write(
                self.style.SUCCESS(f'Successfully created {count} test users:')
            )
            for user in created_users:
                self.print_user_info(user, password)

    def create_user(self, username, password, email=None):
        """Create a user with profile and notification settings."""
        if not email:
            email = f"{username}@example.com"
        
        # Create user
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            is_active=True,
            are_guidelines_accepted=True,
            is_email_verified=True
        )
        
        # Create or update profile
        profile, created = UserProfile.objects.get_or_create(
            user=user,
            defaults={
                'name': username.capitalize(),
                'bio': f'Test user {username}',
                'location': 'Test City',
                'followers_count_visible': True,
                'community_posts_visible': True
            }
        )
        
        # Create notification settings
        UserNotificationsSettings.objects.get_or_create(
            user=user,
            defaults={
                'post_comment_notifications': True,
                'post_reaction_notifications': True,
                'follow_notifications': True,
                'connection_request_notifications': True,
                'connection_confirmed_notifications': True,
                'community_invite_notifications': True,
                'post_comment_reply_notifications': True,
                'post_comment_reaction_notifications': True,
                'community_new_post_notifications': False,
            }
        )
        
        return user

    def print_user_info(self, user, password):
        """Print user information in a formatted way"""
        self.stdout.write("")
        self.stdout.write(self.style.SUCCESS("=" * 50))
        self.stdout.write(self.style.SUCCESS(f"📱 USER CREATED FOR MOBILE APP"))
        self.stdout.write(self.style.SUCCESS("=" * 50))
        self.stdout.write(f"👤 Username: {user.username}")
        self.stdout.write(f"📧 Email: {user.email}")
        self.stdout.write(f"🔑 Password: {password}")
        self.stdout.write(f"✅ Status: Active")
        self.stdout.write(f"🆔 User ID: {user.id}")
        self.stdout.write(self.style.SUCCESS("=" * 50))
        self.stdout.write("")
