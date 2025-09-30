import os
from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'kongo.settings')

app = Celery('kongo')

# Use Redis as the broker and result backend
redis_host = os.environ.get('REDIS_HOST', 'redis')
redis_port = os.environ.get('REDIS_PORT', '6379')
redis_password = os.environ.get('REDIS_PASSWORD', '')
redis_db = os.environ.get('CELERY_REDIS_DB', '0')

if redis_password:
    redis_url = f'redis://:{redis_password}@{redis_host}:{redis_port}/{redis_db}'
else:
    redis_url = f'redis://{redis_host}:{redis_port}/{redis_db}'

app.conf.broker_url = redis_url
app.conf.result_backend = redis_url

app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()