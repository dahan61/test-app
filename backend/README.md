# Django Backend API

Django REST Framework API for the test-app project.

## Quick Start

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Set up environment variables (create `.env` file):
```env
SECRET_KEY=your-secret-key-here
DEBUG=True
DB_NAME=testapp_db
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=localhost
DB_PORT=5432
```

3. Make sure PostgreSQL is running (via Docker Compose):
```bash
docker-compose up -d
```

4. Run migrations:
```bash
python manage.py makemigrations
python manage.py migrate
```

5. Start the server:
```bash
python manage.py runserver
```

## API Endpoints

- `GET /api/health/` - Health check
- `GET /api/items/` - List items
- `POST /api/items/` - Create item
- `GET /api/items/{id}/` - Get item
- `PATCH /api/items/{id}/` - Update item
- `DELETE /api/items/{id}/` - Delete item

## Admin Panel

Access the Django admin at `http://localhost:8000/admin/`

Create a superuser:
```bash
python manage.py createsuperuser
```



