# 🐳 DEPLOY DENGAN DOCKER (VIA SSH)
## aaPanel Hanya untuk Proxy & SSL

---

## 📋 PERSIAPAN

Yang kamu butuhkan:
1. ✅ SSH access ke server (PuTTY/CMD)
2. ✅ File sudah di-upload via FileZilla
3. ✅ aaPanel untuk reverse proxy & SSL saja

---

## 🚀 LANGKAH 1: UPLOAD FILE

Pakai FileZilla, upload semua file ke:
```
/www/wwwroot/queenifyofficial.site
```

---

## 🚀 LANGKAH 2: MASUK KE SERVER (SSH)

### Via CMD (Windows 10/11):
```
ssh root@[IP-SERVER]
```

### Via PuTTY:
- Host: [IP Server]
- Port: 22
- Login: root

---

## 🚀 LANGKAH 3: INSTALL DOCKER (Copy Paste Satu-Satu)

```bash
# 1. Update system
apt update

# 2. Install Docker (tunggu 2-5 menit)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# 3. Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 4. Verify
docker --version
docker-compose --version
```

✅ Kalau muncul versi, berarti berhasil!

---

## 🚀 LANGKAH 4: SETUP & JALANKAN APLIKASI

```bash
# 1. Masuk ke folder aplikasi
cd /www/wwwroot/queenifyofficial.site

# 2. Copy environment file
cp .env.production .env

# 3. Edit JWT_SECRET (PENTING!)
nano .env
```

**Di nano editor:**
- Cari baris: `JWT_SECRET=your-super-secret-jwt-key-change-this-in-production`
- Ganti dengan: `JWT_SECRET=RahasiaSuperKuatAbcd1234!@#$%`
- Tekan `Ctrl + X`, lalu `Y`, lalu `Enter`

```bash
# 4. Build & Jalankan Docker
docker-compose up -d --build
```

⏱️ **TUNGGU 5-10 MENIT** (proses build Docker)

```bash
# 5. Cek status container
docker-compose ps
```

✅ Harusnya muncul 2 container dengan status "Up":
```
user-identity-backend    Up    0.0.0.0:3040->3040/tcp
user-identity-frontend   Up    0.0.0.0:3000->80/tcp
```

```bash
# 6. Test backend
curl http://localhost:3040/
```

✅ Harusnya response: `{"message":"User Identity API is running"}`

---

## 🚀 LANGKAH 5: SETUP SUPABASE DATABASE

### 1. Buka Supabase Dashboard:
https://supabase.com/

### 2. Login & Pilih Project

### 3. Klik SQL Editor

### 4. Copy Paste SQL ini & Run:

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
('3', 'Budi Santoso', 'budi@mail.com', 'employee', 'active', 'user123'),
('4', 'Siti Aminah', 'siti@mail.com', 'employee', 'inactive', 'user123'),
('5', 'Andi Wijaya', 'andi@mail.com', 'employee', 'active', 'user123');
```

✅ Klik **Run** → Database siap!

---

## 🚀 LANGKAH 6: SETUP DI AAPANEL

### A. Login aaPanel:
```
http://[IP-SERVER]:7800
```

### B. Tambah Website:

1. Klik **Website** → **Add site**
2. Isi:
   - Domain: `queenifyofficial.site`
   - Juga tambahkan: `www.queenifyofficial.site`
   - Root directory: `/www/wwwroot/queenifyofficial.site`
   - PHP: Pure static / Don't set
3. Klik **Submit**

### C. Setup Reverse Proxy (PENTING!):

**1. Proxy untuk Backend API:**

- Klik domain **queenifyofficial.site**
- Klik tab **Reverse proxy**
- Klik **Add reverse proxy**
- Isi:
  ```
  Proxy name: Backend API
  Target URL: http://127.0.0.1:3040
  Proxy directory: /api
  ```
- Centang **Enable**
- Klik **Submit**

**2. Proxy untuk Frontend:**

- Klik **Add reverse proxy** lagi
- Isi:
  ```
  Proxy name: Frontend
  Target URL: http://127.0.0.1:3000
  Proxy directory: /
  ```
- Centang **Enable**
- Klik **Submit**

### D. Install SSL Certificate:

1. Klik tab **SSL**
2. Pilih **Let's Encrypt**
3. Centang domain `queenifyofficial.site` dan `www.queenifyofficial.site`
4. Klik **Apply**
5. Tunggu 1-2 menit
6. Setelah berhasil, aktifkan **Force HTTPS**

---

## ✅ LANGKAH 7: TEST WEBSITE

### 1. Buka Browser:
```
https://queenifyofficial.site
```

### 2. Harusnya muncul halaman Login!

### 3. Test Login:
```
Email: admin@mail.com
Password: admin123
```

### 4. Kalau berhasil masuk → **SELAMAT! 🎉**

---

## 🔧 PERINTAH BERGUNA

```bash
# Lihat status container
docker-compose ps

# Lihat logs
docker-compose logs
docker-compose logs backend
docker-compose logs frontend

# Restart container
docker-compose restart

# Stop semua
docker-compose down

# Start ulang
docker-compose up -d

# Rebuild (kalau ada update)
docker-compose down
docker-compose up -d --build

# Lihat logs real-time
docker-compose logs -f backend
```

---

## 🆘 TROUBLESHOOTING

### Container tidak berjalan:
```bash
docker-compose logs
```

### Port sudah dipakai:
```bash
# Cek port 3040
netstat -tulpn | grep 3040

# Kill process
kill -9 [PID]
```

### Rebuild dari awal:
```bash
docker-compose down -v
docker-compose up -d --build
```

### Hapus semua image & container:
```bash
docker system prune -a
docker-compose up -d --build
```

---

## 📊 MONITORING

```bash
# CPU & Memory usage
docker stats

# Disk space
df -h

# Docker disk usage
docker system df
```

---

## 🔄 UPDATE APLIKASI (Kalau Ada Perubahan)

```bash
cd /www/wwwroot/queenifyofficial.site

# Backup dulu
docker-compose down

# Update code (via FileZilla atau git pull)

# Rebuild & restart
docker-compose up -d --build
```

---

## ✅ KESIMPULAN

**Docker dijalankan via SSH** (command line):
- ✅ Install Docker via SSH
- ✅ Build & run via `docker-compose`
- ✅ Monitoring via SSH command

**aaPanel hanya untuk:**
- ✅ Reverse proxy (routing traffic)
- ✅ SSL certificate
- ✅ File management (opsional)

**aaPanel TIDAK mengelola Docker!** Semuanya via SSH.

---

**Website live di: https://queenifyofficial.site** 🎉
