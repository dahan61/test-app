# React + Django Full-Stack App

A full-stack application with React frontend (Vite) and Django REST API backend, using PostgreSQL database.

## Project Structure

```
test-app/
├── backend/          # Django backend
│   ├── api/          # Django REST API app
│   ├── config/       # Django project settings
│   └── manage.py     # Django management script
├── src/              # React frontend
├── docker-compose.yml # PostgreSQL container
└── package.json      # Frontend dependencies
```

## Prerequisites

- Node.js (v16 or higher)
- Python 3.8+
- npm or yarn

## Setup Instructions

### 1. Backend Setup (Django)

**Option A: Using the setup script (Recommended for Windows/PowerShell):**

From the project root, run:
```powershell
.\setup-backend.ps1
```

This will automatically:
- Install Python dependencies
- Create `.env` file if it doesn't exist
- Run database migrations

**Option B: Manual setup:**

1. **Fix PATH issue in PowerShell (if pip is not recognized):**
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

2. Navigate to the backend directory:
```bash
cd backend
```

3. Install Python dependencies:
```bash
pip install -r requirements.txt
```

4. Create a `.env` file in the `backend/` directory (optional):
```env
SECRET_KEY=your-secret-key-here
DEBUG=True
```

5. Run database migrations:
```bash
python manage.py makemigrations
python manage.py migrate
```

7. Create a superuser (optional, for admin panel):
```bash
python manage.py createsuperuser
```

8. Start the Django development server:
```bash
python manage.py runserver
```

Or use the helper script:
```powershell
cd backend
.\run.ps1
```

The API will be available at `http://localhost:8000`

### 2. Frontend Setup (React)

1. Install dependencies (from project root):
```bash
npm install
```

2. Create a `.env` file in the project root (optional):
```env
VITE_API_URL=http://localhost:8000/api
```

3. Start the development server:
```bash
npm run dev
```

The frontend will be available at `http://localhost:5173`

## API Endpoints

- `GET /api/health/` - Health check endpoint
- `GET /api/items/` - List all items
- `POST /api/items/` - Create a new item
- `GET /api/items/{id}/` - Get a specific item
- `PATCH /api/items/{id}/` - Update an item
- `DELETE /api/items/{id}/` - Delete an item

## Features

- ✅ React frontend with Vite
- ✅ Django REST Framework API
- ✅ SQLite database (simple, no setup required)
- ✅ CORS configured for frontend-backend communication
- ✅ Full CRUD operations for Items

## Development

### Running Both Servers

**Terminal 1 - Backend:**
```bash
cd backend
python manage.py runserver
```

**Terminal 2 - Frontend:**
```bash
npm run dev
```

**Terminal 3 - Database (if not running):**
```bash
docker-compose up -d
```

### Building for Production

**Frontend:**
```bash
npm run build
```

**Backend:**
The Django app can be deployed to various platforms. For Vercel, you may need additional configuration.

## Technologies Used

- **Frontend:** React, Vite
- **Backend:** Django, Django REST Framework
- **Database:** SQLite (simple file-based database)

## License

MIT
