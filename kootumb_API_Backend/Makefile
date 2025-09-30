makemessages:
	django-admin makemessages --all

compilemessages_en:
	django-admin compilemessages --locale=en

compilemessages_es:
	django-admin compilemessages --locale=es

setup:
	pip install -r requirements.txt
	python manage.py migrate
	make load_fixtures

migrate:
	python manage.py migrate

makemigrations:
	python manage.py makemigrations

test:
	python manage.py test

runserver:
	python manage.py runserver

runserver_public:
	python manage.py runserver 0.0.0.0:8000

celery_worker:
	celery -A kongo worker -l info

celery_beat:
	celery -A kongo beat -l info

load_fixtures: load_circles_fixtures load_emoji_fixtures load_badges_fixtures load_categories_fixtures load_languages_fixtures

load_circles_fixtures:
	python manage.py loaddata circles.json

load_emoji_fixtures:
	python manage.py loaddata emoji-groups.json
	python manage.py loaddata emojis.json

load_badges_fixtures:
	python manage.py loaddata badges.json

load_categories_fixtures:
	python manage.py loaddata categories.json
	python manage.py loaddata moderation_categories.json

load_languages_fixtures:
	python manage.py loaddata languages.json

clean:
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
