# 🌟 Kootumb - Social Media Platform

A full-stack social media platform built with Django (Backend) and Flutter (Frontend). Kootumb allows users to connect, share content, and build communities.

## 📱 Features

- **User Authentication & Profiles** - Secure registration, login, and profile management
- **Social Networking** - Follow users, create connections, and build circles
- **Content Sharing** - Post updates, images, and videos
- **Communities** - Create and join communities around shared interests
- **Real-time Notifications** - Stay updated with likes, comments, and follows
- **Mobile-First Design** - Responsive Flutter app optimized for mobile devices
- **Cross-Platform** - Supports Android and iOS

## 🏗️ Architecture

### Backend (Django REST API)
- **Framework**: Django 2.2.28 with Django REST Framework
- **Database**: MySQL 8.0.43
- **Authentication**: JWT Token-based authentication
- **API Documentation**: RESTful API with comprehensive endpoints
- **Features**: User management, content moderation, social features

### Frontend (Flutter Mobile App)
- **Framework**: Flutter 3.32.4
- **Platform**: Android 16 (API 36) with 16 KB page size support
- **State Management**: Provider pattern
- **HTTP Client**: Custom HTTP service with authentication
- **UI**: Material Design with custom theming

## 🚀 Getting Started

### Prerequisites

- Python 3.12+
- Flutter 3.32.4+
- MySQL 8.0+
- Android SDK (for mobile development)
- Git

### Backend Setup

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd kootumb
   ```

2. **Set up Django Backend**
   ```bash
   cd kootumb_API_Backend
   
   # Create virtual environment
   python3 -m venv env
   source env/bin/activate  # On Windows: env\Scripts\activate
   
   # Install dependencies
   pip install -r requirements.txt
   
   # Set up database
   cp .env.example .env
   # Edit .env with your database credentials
   
   # Run migrations
   python manage.py migrate
   
   # Create user profiles for existing users
   python manage.py fix_user_missing_related_items
   
   # Start the server
   python manage.py runserver 0.0.0.0:8000
   ```

3. **MySQL Database Setup**
   ```sql
   CREATE DATABASE kootumb;
   CREATE USER 'kootumb'@'localhost' IDENTIFIED BY 'kootumb';
   GRANT ALL PRIVILEGES ON kootumb.* TO 'kootumb'@'localhost';
   FLUSH PRIVILEGES;
   ```

### Frontend Setup

1. **Set up Flutter App**
   ```bash
   cd kootumb_Frontend_Flutter
   
   # Install Flutter dependencies
   flutter pub get
   
   # Copy environment configuration
   cp .sample.env.json assets/.env.json
   # Edit assets/.env.json with your API URL
   
   # Run the app
   flutter run
   ```

2. **Environment Configuration**
   Edit `assets/.env.json`:
   ```json
   {
     "API_URL": "http://10.0.2.2:8000/",
     "MAGIC_HEADER_NAME": "",
     "MAGIC_HEADER_VALUE": "",
     "INTERCOM_APP_ID": "",
     "INTERCOM_IOS_KEY": "",
     "INTERCOM_ANDROID_KEY": "",
     "SENTRY_DSN": "",
     "OPENBOOK_SOCIAL_API_URL": "http://10.0.2.2:8000/",
     "LINK_PREVIEWS_TRUSTED_PROXY_URL": ""
   }
   ```

## 🔧 Configuration

### Backend Configuration

Key settings in `kongo/settings.py`:
- **Database**: MySQL configuration
- **CORS**: Enabled for Flutter mobile app
- **Authentication**: JWT token settings
- **Media Files**: User uploads and static files
- **Email**: SMTP configuration for notifications

### Frontend Configuration

Key configurations:
- **API Endpoints**: Configure backend URL in `.env.json`
- **Android**: Targets API 36 with 16 KB page size support
- **Build**: Production-ready AAB builds for Google Play

## 📱 Mobile App Features

- **Google Play Compliant**: Supports Android 16 and 16 KB page size requirements
- **Production Ready**: Optimized AAB builds (108.3MB)
- **Cross-Origin Support**: CORS configured for API communication
- **Offline Support**: Caching and offline functionality
- **Push Notifications**: OneSignal integration ready

## 🛠️ Development

### Running in Development

1. **Backend**:
   ```bash
   cd kootumb_API_Backend
   source env/bin/activate
   python manage.py runserver 0.0.0.0:8000
   ```

2. **Frontend**:
   ```bash
   cd kootumb_Frontend_Flutter
   flutter run
   ```

### Building for Production

1. **Backend Deployment**:
   - Configure production database
   - Set up environment variables
   - Collect static files: `python manage.py collectstatic`
   - Set DEBUG=False in production

2. **Flutter App Build**:
   ```bash
   flutter build apk --release  # For APK
   flutter build appbundle      # For Google Play Store
   ```

## 🔐 Security Features

- **JWT Authentication**: Secure token-based authentication
- **CORS Configuration**: Properly configured cross-origin requests
- **Input Validation**: Comprehensive form validation
- **User Permissions**: Role-based access control
- **SQL Injection Protection**: Django ORM prevents SQL injection
- **XSS Protection**: Built-in Django security features

## 📚 API Documentation

The backend provides a comprehensive REST API:

- **Authentication**: `/api/auth/` - Login, register, password reset
- **Users**: `/api/auth/users/` - User management and profiles
- **Posts**: `/api/posts/` - Content creation and sharing
- **Communities**: `/api/communities/` - Community management
- **Social**: `/api/follows/`, `/api/connections/` - Social features
- **Notifications**: `/api/notifications/` - Real-time notifications

## 🎯 Roadmap

- [ ] iOS App Development
- [ ] Web Application (React/Vue)
- [ ] Real-time Chat Features
- [ ] Advanced Content Moderation
- [ ] Analytics Dashboard
- [ ] Video Calling Integration
- [ ] Enhanced Community Features

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter any issues:

1. Check the [Issues](../../issues) section
2. Review the setup documentation
3. Ensure all dependencies are properly installed
4. Verify database and environment configurations

## 🏆 Acknowledgments

- Django REST Framework for the robust backend API
- Flutter team for the excellent mobile framework
- Material Design for UI/UX guidelines
- Open source community for various packages and tools

---

**Built with ❤️ by Sakshi**

*Kootumb - Connecting people, building communities*
