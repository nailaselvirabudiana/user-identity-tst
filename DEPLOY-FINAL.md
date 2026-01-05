# 🚀 LANGKAH TERAKHIR: Deploy di Server

## ✅ Persiapan: Upload File ke Server

Via FileZilla, upload file-file ini ke `/www/wwwroot/queenifyofficial.site`:
- ✅ `docker-compose.prod.yml`
- ✅ `.env.production`
- ✅ `pull-and-run.sh`

---

## 📝 JALANKAN DI SERVER (Copy Paste)

### 1. SSH ke Server:
```bash
ssh root@[IP-SERVER-KAMU]
```

### 2. Masuk ke Folder:
```bash
cd /www/wwwroot/queenifyofficial.site
```

### 3. Jalankan Script:
```bash
chmod +x pull-and-run.sh
./pull-and-run.sh
```

**Script akan otomatis:**
- ✅ Install Docker & Docker Compose (jika belum ada)
- ✅ Setup environment (.env)
- ✅ Pull images dari Docker Hub (cepat!)
- ✅ Run containers
- ✅ Test backend & frontend

⏱️ **Tunggu 2-5 menit**

---

## 🌐 Setup di aaPanel

### 1. Login aaPanel:
```
http://[IP-SERVER]:7800
```

### 2. Tambah Website:
- Website → Add site
- Domain: `queenifyofficial.site` + `www.queenifyofficial.site`
- Root: `/www/wwwroot/queenifyofficial.site`
- Submit

### 3. Reverse Proxy - Backend:
- Website → queenifyofficial.site → Reverse proxy
- Add proxy:
  ```
  Name: Backend API
  Target URL: http://127.0.0.1:3040
  Proxy directory: /api
  ```
- Enable → Submit

### 4. Reverse Proxy - Frontend:
- Add proxy lagi:
  ```
  Name: Frontend
  Target URL: http://127.0.0.1:3060
  Proxy directory: /
  ```
- Enable → Submit

### 5. Install SSL:
- SSL → Let's Encrypt
- Centang domain
- Apply
- Force HTTPS: ON

---

## 🗄️ Setup Database Supabase

1. Buka https://supabase.com/
2. Login → SQL Editor
3. Run query ini:

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

## ✅ TEST WEBSITE

Buka: **https://queenifyofficial.site**

Login:
```
Email: admin@mail.com
Password: admin123
```

**Kalau berhasil masuk → SELAMAT! 🎉**

---

## 🔧 Perintah Berguna di Server

```bash
# Cek status container
docker-compose -f docker-compose.prod.yml ps

# Lihat logs
docker-compose -f docker-compose.prod.yml logs

# Restart
docker-compose -f docker-compose.prod.yml restart

# Stop
docker-compose -f docker-compose.prod.yml down

# Update (pull image baru)
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

---

**Total waktu: 10-15 menit** ⏱️

Website live di: **https://queenifyofficial.site** 🚀
