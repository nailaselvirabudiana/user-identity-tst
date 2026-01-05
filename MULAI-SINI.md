# 🎯 CARA CEPAT: 3 LANGKAH SAJA!

## 📦 PERSIAPAN (Di Komputer)
1. Download **FileZilla**: https://filezilla-project.org/
2. Download **PuTTY** (untuk Windows): https://www.putty.org/

---

## 🚀 LANGKAH 1: UPLOAD FILE (5 menit)

### Pakai FileZilla:
1. Buka FileZilla
2. Isi di bagian atas:
   ```
   Host: [IP server]
   Username: root
   Password: [password server]
   Port: 22
   ```
3. Klik **Quickconnect**
4. Di sisi KANAN, ketik: `/www/wwwroot/queenifyofficial.site`
5. Di sisi KIRI, buka folder `user-identity-tst`
6. **Drag semua file** dari KIRI ke KANAN
7. Tunggu sampai selesai upload

✅ **Selesai upload!**

---

## 🚀 LANGKAH 2: JALANKAN SCRIPT OTOMATIS (10 menit)

### A. Masuk ke Server (SSH):

**Cara 1: Pakai CMD (Windows 10/11)**
```
1. Tekan Windows + R
2. Ketik: cmd
3. Enter
4. Ketik: ssh root@[IP-SERVER]
5. Masukkan password
```

**Cara 2: Pakai PuTTY**
```
1. Buka PuTTY
2. Isi Host Name: [IP server]
3. Port: 22
4. Klik Open
5. Login: root
6. Password: [password]
```

### B. Jalankan Script Otomatis:

**Copy paste perintah ini SATU PER SATU:**

```bash
# 1. Masuk ke folder
cd /www/wwwroot/queenifyofficial.site

# 2. Buat script executable
chmod +x deploy.sh

# 3. Jalankan deploy otomatis
./deploy.sh
```

Script akan otomatis:
- ✅ Install Docker
- ✅ Install Docker Compose  
- ✅ Setup environment
- ✅ Build aplikasi
- ✅ Jalankan container

**Ikuti instruksi di layar!**

⏱️ Tunggu 5-10 menit sampai selesai.

---

## 🚀 LANGKAH 3: SETTING DI AAPANEL (5 menit)

### A. Buat Database Supabase:
1. Buka https://supabase.com/
2. Login / Sign up
3. Klik **SQL Editor**
4. Copy paste & Run SQL ini:

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

### B. Setup di aaPanel:

1. **Login aaPanel**: `http://[IP-SERVER]:7800`

2. **Tambah Website:**
   - Klik Website → Add site
   - Domain: `queenifyofficial.site`
   - Root: `/www/wwwroot/queenifyofficial.site`
   - Submit

3. **Setup Proxy:**
   - Klik domain → Reverse proxy
   - Add proxy #1:
     ```
     Name: Backend
     URL: http://127.0.0.1:3040
     Directory: /api
     ```
   - Add proxy #2:
     ```
     Name: Frontend
     URL: http://127.0.0.1:3000
     Directory: /
     ```

4. **Install SSL:**
   - Klik SSL → Let's Encrypt
   - Centang domain
   - Apply
   - Aktifkan Force HTTPS

---

## ✅ SELESAI!

Buka browser: **https://queenifyofficial.site**

Login:
```
Email: admin@mail.com
Password: admin123
```

---

## 🆘 KALAU ERROR?

```bash
# Lihat logs
docker-compose logs

# Restart
docker-compose restart

# Rebuild
docker-compose down
docker-compose up -d --build
```

---

**Total waktu: ~20 menit** ⏱️

Baca **PANDUAN-PEMULA.md** untuk penjelasan detail!
