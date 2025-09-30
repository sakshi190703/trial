#!/bin/bash
# Production ASGI server startup script

# Activate virtual environment
source env/bin/activate

# Start uvicorn with production settings
echo "🚀 Starting Kootumb Backend with Uvicorn ASGI server..."
uvicorn kongo.asgi:application \
    --host 0.0.0.0 \
    --port 8000 \
    --workers 4 \
    --access-log \
    --use-colors
