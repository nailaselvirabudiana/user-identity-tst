# User Identity Management - Frontend

Frontend React untuk sistem manajemen identitas karyawan.

## Fitur

### Admin Dashboard
- Login sebagai admin
- Melihat daftar semua karyawan
- Menambah karyawan baru
- Mengedit data karyawan (nama & email)
- Mengubah status karyawan (active/inactive/resigned)
- Filter karyawan berdasarkan status

### Employee Dashboard
- Login sebagai karyawan
- Melihat profil sendiri
- Mengedit profil sendiri (nama & email)

## Instalasi

```bash
# Install dependencies
npm install

# Jalankan development server
npm run dev

# Build untuk production
npm run build
```

## Konfigurasi

Backend API URL dikonfigurasi di `src/api/api.js`:
```javascript
const API_URL = 'http://localhost:5000/api'
```

Sesuaikan dengan URL backend Anda jika berbeda.

## Credential Demo

**Admin:**
- Email: admin@mail.com
- Password: admin123

**Employee:**
- Email: naila@mail.com
- Password: user123

## Teknologi

- React 18
- React Router DOM 6
- Axios
- Vite
- CSS Vanilla

## Struktur Folder

```
src/
├── api/
│   └── api.js              # Axios instance & API functions
├── components/
│   └── UserModal.jsx       # Modal untuk create/edit user
├── pages/
│   ├── Login.jsx          # Halaman login
│   ├── AdminDashboard.jsx # Dashboard admin
│   └── EmployeeDashboard.jsx # Dashboard employee
├── App.jsx                # Main app component
├── main.jsx              # Entry point
└── index.css             # Global styles
```

## API Endpoints yang Digunakan

- `POST /api/auth/login` - Login
- `GET /api/users` - Get all users (admin only)
- `GET /api/users/:id` - Get user profile
- `POST /api/users` - Create new user (admin only)
- `PATCH /api/users/:id` - Update user (name & email)
- `PATCH /api/users/:id/status` - Update user status (admin only)
