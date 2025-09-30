#!/usr/bin/env python3
"""
KOOTUMB BACKEND - ONE-COMMAND SETUP & START SCRIPT
==================================================
This script handles everything:
- Virtual environment setup
- Package installation with progress tracking
- Django server startup
- Comprehensive dependency resolution

Usage:
  python3 start.py --quick    # Quick start (if env exists)
  python3 start.py           # Full setup + start
"""

import os
import sys
import subprocess
import platform
import signal
import time
import shlex

# Color codes for better output
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033[1m'
    END = '\033[0m'

def print_banner():
    """Display welcome banner"""
    print(f"\n{Colors.CYAN}======================================================================{Colors.END}")
    print(f"{Colors.BOLD}{Colors.WHITE}🚀 KOOTUMB BACKEND - COMPLETE SETUP & START{Colors.END}")
    print(f"{Colors.CYAN}======================================================================{Colors.END}")
    print(f"{Colors.WHITE}Setting up your complete backend environment...{Colors.END}")
    print(f"{Colors.WHITE}This will install ALL packages and configure everything!{Colors.END}\n")

def print_success(message):
    print(f"{Colors.GREEN}✅ {message}{Colors.END}")

def print_error(message):
    print(f"{Colors.RED}❌ {message}{Colors.END}")

def print_warning(message):
    print(f"{Colors.YELLOW}⚠️  {message}{Colors.END}")

def print_info(message):
    print(f"{Colors.BLUE}ℹ️  {message}{Colors.END}")

def get_python_executable():
    """Get the correct Python executable"""
    if platform.system() == "Windows":
        return "python"
    return "python3"

def get_pip_executable():
    """Get the correct pip executable"""
    venv_path = "env"
    if platform.system() == "Windows":
        return f"{venv_path}\\Scripts\\pip"
    return f"{venv_path}/bin/pip"

def run_command(command, description, check=True, show_output=False):
    """Run a shell command with error handling and progress tracking"""
    try:
        if show_output:
            result = subprocess.run(command, shell=True, check=check)
        else:
            result = subprocess.run(command, shell=True, check=check, 
                                  capture_output=True, text=True)
        return result
    except subprocess.CalledProcessError as e:
        return None
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}⚠️  Operation cancelled by user{Colors.END}")
        raise

def install_packages_with_progress():
    """Install packages one by one with progress tracking"""
    
    # All packages in the correct order to avoid dependency issues
    packages_to_install = [
        # Core packages first
        "setuptools>=40.0.0",
        "Django==2.2.28",
        "djangorestframework==3.12.4",
        "django-replicated>=2.5.0",
        
        # Essential utilities
        "PyJWT==1.7.1",
        "python-dotenv==0.19.2",
        "python-dateutil==2.8.2",
        "pytz==2022.1",
        "requests==2.28.1",
        
        # File processing
        "Pillow==8.4.0",
        "pilkit>=2.0.0",
        "django-imagekit>=4.1.0",
        
        # Database and caching
        "redis>=4.3.4",
        "django-redis==4.12.1",
        "celery>=5.0.0",
        "django-rq>=2.5.0",
        
        # Storage
        "boto3>=1.0.0",
        "django-storages>=1.13.0",
        
        # API frameworks
        "rest-framework-generic-relations>=2.0.0",
        "django-ordered-model>=3.4.3",
        "django-cors-headers>=3.13.0",
        "django-extensions>=3.2.0",
        "django-cursor-pagination>=0.1.4",
        "django-compressor>=4.0.0",
        "django-media-fixtures>=1.0.0",
        "tldextract>=3.4.0",
        "django-bulk-update>=2.2.0",
        "django-mptt>=0.13.4",
        "django-activity-stream>=1.4.0",
        "django-modeltranslation>=0.18.0",
        "django-nose>=1.4.7",
        
        # New packages discovered during runtime
        "django-positions>=0.6.0",
        "PyYAML>=6.0.2",
        "django-proxy>=1.3.0",
        "shutilwhich>=1.1.0",
        "spectra>=0.1.0",
        "url-normalize>=2.2.1",
        "urlextract>=1.9.0",
        "onesignal==0.1.3",
        "onesignal-client==0.0.2",
    ]
    
    pip_cmd = get_pip_executable()
    print(f"\n{Colors.PURPLE}📦 Installing {len(packages_to_install)} packages...{Colors.END}\n")
    
    total_installed = 0
    total_failed = 0
    failed_packages = []
    
    for i, package in enumerate(packages_to_install, 1):
        package_name = package.split("==")[0].split(">=")[0]
        print(f"  [{i:2d}/{len(packages_to_install)}] {package_name:<30}", end=" ", flush=True)
        
        # Use shlex.quote to properly escape package names with version specifiers
        result = run_command(f'{pip_cmd} install {shlex.quote(package)}', 
                           f"Installing {package_name}", 
                           check=False)
        
        if result and result.returncode == 0:
            print(f"{Colors.GREEN}✅{Colors.END}")
            total_installed += 1
        else:
            print(f"{Colors.RED}❌{Colors.END}")
            total_failed += 1
            failed_packages.append(package_name)
    
    # Summary
    print(f"\n{Colors.BOLD}📊 Installation Summary:{Colors.END}")
    print_success(f"Successfully installed: {total_installed} packages")
    
    if total_failed > 0:
        print_error(f"Failed to install: {total_failed} packages")
        print(f"{Colors.YELLOW}Failed packages: {', '.join(failed_packages)}{Colors.END}")
        print_info("The application may still work without some packages")
    
    return total_failed < 5  # Allow some failures

def setup_environment():
    """Main setup function"""
    print_banner()
    
    python_cmd = get_python_executable()
    pip_cmd = get_pip_executable()
    
    # Step 1: Create virtual environment
    print(f"{Colors.BOLD}[1/6] Creating virtual environment{Colors.END}")
    if not os.path.exists("env"):
        result = run_command(f"{python_cmd} -m venv env", "Creating virtual environment")
        if result and result.returncode == 0:
            print_success("Virtual environment created")
        else:
            print_error("Failed to create virtual environment")
            return False
    else:
        print_success("Virtual environment already exists")
    
    # Step 2: Upgrade pip
    print(f"\n{Colors.BOLD}[2/6] Upgrading pip{Colors.END}")
    result = run_command(f"{pip_cmd} install --upgrade pip", "Upgrading pip")
    if result and result.returncode == 0:
        print_success("Pip upgraded successfully")
    else:
        print_warning("Pip upgrade had issues (continuing anyway)")
    
    # Step 3: Install all packages
    print(f"\n{Colors.BOLD}[3/6] Installing ALL required packages{Colors.END}")
    if not install_packages_with_progress():
        print_error("Too many package installation failures")
        return False
    
    # Step 4: Database migrations (optional, might fail if DB not configured)
    print(f"\n{Colors.BOLD}[4/6] Checking database setup{Colors.END}")
    python_manage = f"env/bin/python manage.py" if platform.system() != "Windows" else f"env\\Scripts\\python manage.py"
    
    result = run_command(f"{python_manage} check", "Checking Django configuration", check=False)
    if result and result.returncode == 0:
        print_success("Django configuration is valid")
        
        # Try to run migrations (optional)
        print_info("Attempting to run database migrations...")
        result = run_command(f"{python_manage} migrate", "Running migrations", check=False)
        if result and result.returncode == 0:
            print_success("Database migrations completed")
        else:
            print_warning("Migrations failed (DB might not be configured)")
    else:
        print_warning("Django check failed (some components may not be configured)")
    
    # Step 5: Collect static files (optional)
    print(f"\n{Colors.BOLD}[5/6] Collecting static files{Colors.END}")
    result = run_command(f"{python_manage} collectstatic --noinput", "Collecting static files", check=False)
    if result and result.returncode == 0:
        print_success("Static files collected")
    else:
        print_warning("Static files collection failed (continuing anyway)")
    
    # Step 6: Start the server
    print(f"\n{Colors.BOLD}[6/6] Starting Django development server{Colors.END}")
    print_info("Note: Some Redis/cache errors are normal if services aren't running")
    print(f"{Colors.CYAN}🌐 Starting Django development server at http://127.0.0.1:8000/{Colors.END}")
    print(f"{Colors.YELLOW}📝 Press Ctrl+C to stop the server{Colors.END}\n")
    
    try:
        run_command(f"{python_manage} manage.py runserver 0.0.0.0:8000", "Starting Django server", show_output=True)
        return True
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}🛑 Server stopped by user{Colors.END}")
        return True
    except Exception as e:
        print_error(f"Failed to start Django server: {e}")
        return False

def quick_start():
    """Start the server quickly without full setup"""
    print("🚀 Virtual environment detected. Starting server quickly...")
    print("ℹ️  Note: Some cache/Redis errors are normal and can be ignored")
    print()
    
    # Use Django's built-in runserver for Django 2.2 compatibility
    import subprocess
    subprocess.run([
        sys.executable, 'manage.py', 'runserver', '0.0.0.0:8000'
    ])

def main():
    """Main entry point"""
    try:
        # Check for quick start
        if len(sys.argv) > 1 and sys.argv[1] == "--quick":
            if quick_start():
                return
            else:
                # If quick start was cancelled (Ctrl+C), don't run full setup
                print(f"\n{Colors.YELLOW}⚠️  Quick start cancelled. Exiting...{Colors.END}")
                return
        
        # Run full setup
        success = setup_environment()
        
        if success:
            print(f"\n{Colors.GREEN}✅ Backend is ready and running!{Colors.END}")
            print(f"{Colors.CYAN}🌐 Visit http://127.0.0.1:8000/ to see your API{Colors.END}")
        else:
            print(f"\n{Colors.RED}❌ Setup encountered issues.{Colors.END}")
            print(f"{Colors.YELLOW}💡 Try running: python3 start.py --quick{Colors.END}")
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}⚠️  Setup cancelled by user. Exiting...{Colors.END}")
        sys.exit(0)

if __name__ == "__main__":
    main()
