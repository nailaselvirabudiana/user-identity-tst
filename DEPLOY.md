# 🚀 Panduan Deploy ke aaPanel dengan Docker

## 📋 Persiapan

### 1. File yang Sudah Dibuat:
✅ `backend/Dockerfile` - Docker image untuk backend
✅ `frontend/Dockerfile` - Docker image untuk frontend  
✅ `docker-compose.yml` - Orchestrasi semua service
✅ `.env.production` - Konfigurasi production
✅ `nginx.conf` - Konfigurasi web server

---

## 🖥️ Langkah 1: Persiapan Server (di aaPanel)

### 1.1 Install Docker
```bash
# Login ke server via SSH
ssh root@your-server-ip

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verifikasi instalasi
docker --version
docker-compose --version
```

### 1.2 Buat Folder Aplikasi
```bash
mkdir -p /www/wwwroot/queenifyofficial.site
cd /www/wwwroot/queenifyofficial.site
```

---

## 📤 Langkah 2: Upload File ke Server

### Opsi A: Via FTP/SFTP (Mudah untuk Pemula)
1. Download **FileZilla** atau **WinSCP**
2. Connect ke server dengan credentials:
   - Host: IP server Anda
   - Username: root
   - Password: password server
   - Port: 22
3. Upload seluruh folder `user-identity-tst` ke `/www/wwwroot/queenifyofficial.site`

### Opsi B: Via Git (Lebih Cepat)
```bash
cd /www/wwwroot/queenifyofficial.site
git clone <your-repo-url> .
```

---

## 🔧 Langkah 3: Konfigurasi Environment

```bash
# Masuk ke folder aplikasi
cd /www/wwwroot/queenifyofficial.site

# Copy file environment production
cp .env.production .env

# Edit file .env (ganti JWT_SECRET dengan random string)
nano .env
```

**Ubah baris ini:**
```
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
```
Menjadi:
```
JWT_SECRET=GantiDenganStringRandom123456789!@#$%
```

Tekan `Ctrl + X`, lalu `Y`, lalu `Enter` untuk save.

---

## 🐳 Langkah 4: Build & Run Docker

```bash
# Build dan jalankan semua container
docker-compose up -d --build

# Tunggu 2-3 menit untuk build selesai

# Cek status container
docker-compose ps

# Harusnya melihat:
# user-identity-backend   Up   0.0.0.0:3040->3040/tcp
# user-identity-frontend  Up   0.0.0.0:3000->80/tcp
```

---

## 🌐 Langkah 5: Setup Domain di aaPanel

### 5.1 Tambah Website di aaPanel
1. Login ke aaPanel Dashboard
2. Klik **Website** → **Add site**
3. Isi:
   - Domain: `queenifyofficial.site` dan `www.queenifyofficial.site`
   - Root directory: `/www/wwwroot/queenifyofficial.site`
   - PHP version: Pilih "Pure static"

### 5.2 Setup Reverse Proxy untuk Backend
1. Klik domain `queenifyofficial.site`
2. Pilih **Reverse Proxy**
3. Tambah proxy:
   - **Name**: Backend API
   - **Target URL**: `http://127.0.0.1:3040`
   - **Proxy directory**: `/api`
   - **Send domain**: `$host`

4. Klik **Submit**

### 5.3 Setup Reverse Proxy untuk Frontend
1. Tambah proxy lagi:
   - **Name**: Frontend
   - **Target URL**: `http://127.0.0.1:3000`
   - **Proxy directory**: `/`
   - **Send domain**: `$host`

2. Klik **Submit**

### 5.4 Install SSL (HTTPS)
1. Klik **SSL** di website settings
2. Pilih **Let's Encrypt**
3. Centang domain `queenifyofficial.site` dan `www.queenifyofficial.site`
4. Klik **Apply**
5. Tunggu proses selesai
6. Aktifkan **Force HTTPS**

---

## 🗄️ Langkah 6: Setup Database Supabase

1. Buka https://supabase.com/dashboard
2. Masuk ke project Anda
3. Buka **SQL Editor**
4. Jalankan query ini:

```sql
-- Buat tabel users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  role TEXT DEFAULT 'employee',
  status TEXT DEFAULT 'active',
  password TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Insert data awal
INSERT INTO users (id, name, email, role, status, password) VALUES
('1', 'Super Admin', 'admin@mail.com', 'admin', 'active', 'admin123'),
('2', 'Naila Selvira', 'naila@mail.com', 'employee', 'active', 'user123'),
('3', 'Budi Santoso', 'budi@mail.com', 'employee', 'active', 'user123');
```

5. Klik **Run** atau tekan `Ctrl + Enter`

---

## ✅ Langkah 7: Testing

### 7.1 Cek Backend
```bash
curl http://queenifyofficial.site/api/
```
Harusnya response: `{"message":"User Identity API is running"}`

### 7.2 Cek Frontend
Buka browser: `https://queenifyofficial.site`

### 7.3 Test Login
- Email: `admin@mail.com`
- Password: `admin123`

---

## 🔍 Troubleshooting

### Jika container error:
```bash
# Lihat logs backend
docker-compose logs backend

# Lihat logs frontend
docker-compose logs frontend

# Restart semua container
docker-compose restart

# Rebuild jika ada perubahan
docker-compose down
docker-compose up -d --build
```

### Jika website tidak bisa diakses:
1. Cek firewall server (port 80 dan 443 harus terbuka)
2. Cek DNS domain sudah mengarah ke IP server
3. Cek nginx config di aaPanel

### Jika API error:
1. Pastikan environment variables benar di `.env`
2. Pastikan tabel Supabase sudah dibuat
3. Cek logs: `docker-compose logs backend`

---

## 🛠️ Perintah Berguna

```bash
# Lihat container yang berjalan
docker ps

# Stop semua container
docker-compose down

# Start ulang
docker-compose up -d

# Lihat logs real-time
docker-compose logs -f

# Update aplikasi (jika ada perubahan)
git pull
docker-compose down
docker-compose up -d --build

# Hapus semua (HATI-HATI!)
docker-compose down -v
```

---

## 📞 Bantuan Lebih Lanjut

Jika ada masalah:
1. Screenshot error message
2. Jalankan: `docker-compose logs`
3. Copy paste hasilnya untuk dianalisa

---

**Selamat! Aplikasi Anda sekarang sudah online di https://queenifyofficial.site 🎉**
