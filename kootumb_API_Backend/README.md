# 🚀 Kootumb Social Media Backend

A comprehensive Django-based social media platform with modern ASGI deployment.

## ⚡ Quick Start

### One-Command Setup (Recommended)
```bash
# Full setup with environment creation and package installation
python3 start.py

# Quick start (if environment already exists)
python3 start.py --quick
```

### Manual Setup
```bash
# Development server
./scripts/deployment/run_dev.sh

# Production server
./scripts/deployment/run_production.sh
```

## 🏗️ Project Structure

```
kootumb_API_Backend/
├── start.py                    # Main setup script
├── manage.py                   # Django management
├── db.sqlite3                  # Database file
├── scripts/
│   ├── deployment/             # Server deployment scripts
│   │   ├── run_dev.sh         # Development server
│   │   ├── run_production.sh  # Production server
│   │   ├── entrypoint.sh      # Docker entry point
│   │   └── wait-for-it.sh     # Docker dependency script
│   └── fixes/                  # Maintenance scripts
│       ├── fix_ugettext.sh    # Fix deprecated imports
│       ├── fix_string_comparisons.sh
│       └── fix_index_together.sh
├── kongo/                      # Main Django app
├── kongo_auth/                 # User authentication
├── kongo_posts/                # Posts and media
├── kongo_communities/          # Community features
└── [other Django apps]
```

## 🔧 Features

- **User Management** - Registration, profiles, authentication
- **Social Posts** - Text, images, videos, links
- **Communities** - Groups with moderation
- **Real-time Notifications** - Live updates
- **Content Moderation** - Automated and manual moderation
- **Multi-language Support** - i18n ready
- **Mobile API** - REST API for mobile apps

## 🌐 Server Access

After starting the server:
- **Main App**: http://localhost:8000/
- **Admin Panel**: http://localhost:8000/admin/
  - Username: `admin`
  - Password: `admin123`

## 📚 Documentation

- **Scripts**: [SCRIPTS_DOCUMENTATION.md](SCRIPTS_DOCUMENTATION.md)
- **ASGI Setup**: [ASGI_SETUP.md](ASGI_SETUP.md)
- **Backend Status**: [BACKEND_STATUS.md](BACKEND_STATUS.md)

## 🗃️ Database

The project includes a pre-configured SQLite database with:
- ✅ 335 migrations applied
- ✅ Admin user created
- ✅ All tables ready for use

## 🛠️ Development

### Django Commands
```bash
# Create superuser
python manage.py createsuperuser

# Run migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic
```

### Environment
- **Python**: 3.12+
- **Django**: 2.2.28
- **Database**: SQLite (development) / PostgreSQL (production)
- **Server**: Django dev server / Uvicorn ASGI

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
