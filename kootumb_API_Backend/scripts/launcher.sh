#!/bin/bash
# Quick launcher script for Kootumb Backend

echo "🚀 Kootumb Backend Launcher"
echo "=========================="
echo ""
echo "Choose an option:"
echo "1) Quick Start (recommended)"
echo "2) Full Setup" 
echo "3) Development Server"
echo "4) Production Server"
echo "5) Django Admin"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
    1)
        echo "🚀 Starting with quick setup..."
        cd .. && python3 start.py --quick
        ;;
    2)
        echo "🔧 Running full setup..."
        cd .. && python3 start.py
        ;;
    3)
        echo "💻 Starting development server..."
        ./deployment/run_dev.sh
        ;;
    4)
        echo "🏭 Starting production server..."
        ./deployment/run_production.sh
        ;;
    5)
        echo "⚙️ Opening Django shell..."
        cd .. && source env/bin/activate && python manage.py shell
        ;;
    *)
        echo "❌ Invalid option"
        exit 1
        ;;
esac
