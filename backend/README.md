# User Identity Management - Backend

Backend API untuk sistem manajemen identitas karyawan menggunakan Express.js dan Supabase.

## Setup

### 1. Install Dependencies
```bash
npm install
```

### 2. Konfigurasi Environment
File `.env` sudah tersedia dengan konfigurasi Supabase. Pastikan variabel berikut sudah diisi:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
PORT=5000
```

### 3. Jalankan Server
```bash
npm start
```
atau
```bash
npm run dev
```

Server akan berjalan di `http://localhost:5000`

## API Endpoints

### Authentication
- `POST /api/auth/login` - Login user
  - Body: `{ email, password }`
  - Response: `{ token, user }`

### Users
- `GET /api/users` - Get all users (Admin only)
- `GET /api/users/:id` - Get user by ID
- `POST /api/users` - Create new user (Admin only)
  - Body: `{ id, name, email, role, status, password }`
- `PATCH /api/users/:id` - Update user
  - Body: `{ name, email }`
- `PATCH /api/users/:id/status` - Update user status (Admin only)
  - Body: `{ status }` (active/inactive/resigned)

## Testing

Gunakan kredensial berikut untuk testing:
- **Admin**: admin@mail.com / admin123
- **Employee**: naila@mail.com / user123

## Tech Stack
- Express.js
- Supabase (Database & Auth)
- CORS
- dotenv
