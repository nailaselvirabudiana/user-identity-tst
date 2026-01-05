# 🚀 DEPLOY: Build Lokal → Push → Pull di Server

## Strategi Deployment yang Lebih Efisien

**Keuntungan metode ini:**
- ✅ Build di komputer lokal (tidak bebanin server)
- ✅ Server tinggal pull image yang sudah jadi (cepat!)
- ✅ Hemat resource server
- ✅ Bisa test dulu di lokal sebelum deploy
- ✅ Rollback mudah (tinggal pull versi lama)

---

## 📋 PERSIAPAN

### Yang Kamu Butuhkan:

1. **Di Komputer Lokal:**
   - ✅ Docker Desktop installed & running
   - ✅ Akun Docker Hub (gratis di https://hub.docker.com/)
   - ✅ Git Bash / PowerShell

2. **Di Server:**
   - ✅ SSH access
   - ✅ aaPanel untuk reverse proxy & SSL

---

## 🎯 LANGKAH 1: SETUP DOCKER HUB (Sekali Saja)

### 1. Buat Akun Docker Hub:
- Buka https://hub.docker.com/
- Sign up (gratis)
- Catat username kamu (contoh: `johndoe`)

### 2. Install Docker Desktop di Komputer:
- Download: https://www.docker.com/products/docker-desktop
- Install & jalankan Docker Desktop
- Pastikan Docker berjalan (icon whale di taskbar)

---

## 🎯 LANGKAH 2: BUILD & PUSH DARI KOMPUTER LOKAL

### 1. Edit Script Build:

Buka file **`build-and-push.ps1`** di editor (Notepad++)

Cari baris ini:
```powershell
$DOCKER_USERNAME = "yourusername"  # <-- GANTI INI!
```

Ganti dengan username Docker Hub kamu:
```powershell
$DOCKER_USERNAME = "johndoe"  # Username Docker Hub kamu
```

Save file.

### 2. Edit docker-compose.prod.yml:

Buka **`docker-compose.prod.yml`**

Ganti `yourusername` dengan username Docker Hub kamu:
```yaml
services:
  backend:
    image: johndoe/user-identity-backend:latest  # <-- Ganti!
    
  frontend:
    image: johndoe/user-identity-frontend:latest  # <-- Ganti!
```

Save file.

### 3. Jalankan Script Build:

**Buka PowerShell di folder project:**
```powershell
# Masuk ke folder project
cd C:\user-identity-tst

# Jalankan script
.\build-and-push.ps1
```

**Script akan:**
1. Login ke Docker Hub (masukkan username & password)
2. Build backend image (~2-5 menit)
3. Build frontend image (~3-7 menit)
4. Push backend ke Docker Hub (~1-3 menit)
5. Push frontend ke Docker Hub (~2-5 menit)

⏱️ **Total waktu: 10-20 menit**

✅ **Setelah selesai**, images kamu sudah di Docker Hub!

---

## 🎯 LANGKAH 3: UPLOAD FILE KE SERVER

### Via FileZilla:

Upload file-file ini ke `/www/wwwroot/queenifyofficial.site`:
- ✅ `docker-compose.prod.yml` (yang sudah diedit)
- ✅ `.env.production`
- ✅ `pull-and-run.sh`

**TIDAK PERLU upload folder `backend` & `frontend`!** (sudah ada di Docker Hub)

---

## 🎯 LANGKAH 4: PULL & RUN DI SERVER

### 1. SSH ke Server:
```bash
ssh root@[IP-SERVER]
```

### 2. Jalankan Script:
```bash
# Masuk ke folder
cd /www/wwwroot/queenifyofficial.site

# Buat script executable
chmod +x pull-and-run.sh

# Jalankan!
./pull-and-run.sh
```

**Script akan:**
1. Install Docker & Docker Compose (jika belum ada)
2. Setup environment
3. **Pull images dari Docker Hub** (cepat! ~1-3 menit)
4. Run containers
5. Test backend & frontend

✅ **Selesai! Aplikasi running!**

---

## 🎯 LANGKAH 5: SETUP SUPABASE

Sama seperti sebelumnya, buat database:

1. Buka https://supabase.com/
2. SQL Editor
3. Run query:

```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  role TEXT DEFAULT 'employee',
  status TEXT DEFAULT 'active',
  password TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO users (id, name, email, role, status, password) VALUES
('1', 'Super Admin', 'admin@mail.com', 'admin', 'active', 'admin123'),
('2', 'Naila Selvira', 'naila@mail.com', 'employee', 'active', 'user123');
```

---

## 🎯 LANGKAH 6: SETUP AAPANEL

### 1. Tambah Website:
- Domain: `queenifyofficial.site`
- Root: `/www/wwwroot/queenifyofficial.site`

### 2. Reverse Proxy:

**Backend API:**
```
Name: Backend
URL: http://127.0.0.1:3040
Directory: /api
```

**Frontend:**
```
Name: Frontend
URL: http://127.0.0.1:3060
Directory: /
```

### 3. SSL Certificate:
- SSL → Let's Encrypt → Apply
- Force HTTPS: ON

---

## ✅ SELESAI!

Buka browser: **https://queenifyofficial.site**

Login: `admin@mail.com` / `admin123`

---

## 🔄 UPDATE APLIKASI (Kalau Ada Perubahan Code)

### Di Komputer Lokal:
```powershell
# Build & push versi baru
.\build-and-push.ps1
```

### Di Server:
```bash
cd /www/wwwroot/queenifyofficial.site

# Pull image terbaru & restart
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

**Tidak perlu upload code lagi!** Tinggal pull image baru.

---

## 🎨 VERSIONING (Opsional)

Untuk production yang lebih proper, gunakan version tag:

### Di Komputer Lokal:

Edit `build-and-push.ps1`:
```powershell
$VERSION = "v1.0.0"  # Bukan "latest"
```

Build & push:
```powershell
.\build-and-push.ps1
```

### Di docker-compose.prod.yml:
```yaml
backend:
  image: johndoe/user-identity-backend:v1.0.0
frontend:
  image: johndoe/user-identity-frontend:v1.0.0
```

**Keuntungan:**
- Bisa rollback ke versi sebelumnya
- Lebih aman untuk production
- Track version dengan jelas

---

## 📊 PERBANDINGAN

### ❌ Build di Server (Cara Lama):
```
Upload code → Build di server (10 menit) → Run
- Bebanin server
- Lama
- Bisa error karena resource kurang
```

### ✅ Build Lokal → Pull (Cara Baru):
```
Build di lokal (10 menit) → Push (3 menit) → Pull (1 menit) → Run
- Server ringan
- Cepat deploy
- No build error di server
```

---

## 🆘 TROUBLESHOOTING

### "docker login denied"
```powershell
# Login manual
docker login
# Masukkan username & password Docker Hub
```

### "image not found"
Cek apakah images sudah di-push:
- Buka https://hub.docker.com/
- Login
- Cek Repositories → harusnya ada 2 images

### Pull lambat di server
```bash
# Cek koneksi
docker pull hello-world

# Jika lambat, coba lagi atau tunggu
```

---

## 🎯 KESIMPULAN

**Workflow deployment:**
1. 💻 **Lokal**: Edit code → Build → Push ke Docker Hub
2. 🌐 **Server**: Pull image → Run
3. 🔧 **aaPanel**: Reverse proxy & SSL saja

**Keuntungan:**
- Server tidak perlu build (hemat resource!)
- Deploy cepat (tinggal pull)
- Bisa test di lokal dulu
- Version control lebih baik

---

**Happy Deploying! 🚀**
