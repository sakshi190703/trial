#!/bin/bash
# Development ASGI server startup script

# Activate virtual environment
source env/bin/activate

# Start uvicorn with development settings (no file watching due to system limits)
echo "🚀 Starting Kootumb Backend in development mode..."
python -m uvicorn kongo.asgi:application \
    --host 127.0.0.1 \
    --port 8000 \
    --log-level info \
    --access-log \
    --use-colors
