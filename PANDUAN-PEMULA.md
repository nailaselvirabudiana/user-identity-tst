# 🎯 PANDUAN DEPLOY SUPER SIMPEL
## Untuk Pemula yang Baru Pertama Kali Deploy

---

## 📌 YANG KAMU BUTUHKAN:
1. ✅ Komputer dengan FileZilla (download di https://filezilla-project.org/)
2. ✅ Akses ke server (IP, username, password dari penyedia hosting)
3. ✅ Domain sudah mengarah ke IP server
4. ✅ Akun Supabase (database online gratis)

---

## 🎬 LANGKAH 1: UPLOAD FILE KE SERVER

### A. Download & Install FileZilla
1. Download FileZilla dari https://filezilla-project.org/
2. Install seperti biasa (Next, Next, Finish)

### B. Connect ke Server
1. Buka FileZilla
2. Isi kotak di atas:
   ```
   Host: [IP server kamu] (contoh: 103.123.45.67)
   Username: root
   Password: [password dari hosting]
   Port: 22
   ```
3. Klik tombol **"Quickconnect"**
4. Jika muncul peringatan, klik **"OK"** atau **"Trust"**

### C. Upload Semua File
1. **Sebelah KIRI** FileZilla = komputer kamu
2. **Sebelah KANAN** FileZilla = server

**Di sisi KANAN (server):**
- Ketik di Address Bar: `/www/wwwroot/queenifyofficial.site`
- Tekan Enter
- Jika folder tidak ada, klik kanan → Create Directory → buat folder `queenifyofficial.site`

**Di sisi KIRI (komputer):**
- Cari folder `user-identity-tst` di komputer kamu
- Pilih SEMUA file dan folder di dalamnya
- **Drag & Drop** ke sisi KANAN (atau klik kanan → Upload)

**⏱️ Tunggu sampai semua file terupload (bisa 5-10 menit)**

---

## 🎬 LANGKAH 2: MASUK KE SERVER (SSH)

### A. Windows 10/11 (Built-in)
1. Tekan tombol **Windows + R**
2. Ketik: `cmd` lalu Enter
3. Ketik perintah ini:
   ```
   ssh root@[IP-SERVER-KAMU]
   ```
   Contoh: `ssh root@103.123.45.67`
4. Ketik password (tidak terlihat saat mengetik, itu normal)
5. Tekan Enter

### B. Alternatif: Pakai PuTTY
1. Download PuTTY dari https://www.putty.org/
2. Install
3. Buka PuTTY
4. Isi:
   - Host Name: IP server kamu
   - Port: 22
5. Klik **Open**
6. Login dengan:
   - Username: root
   - Password: password server

**✅ Jika sudah muncul tanda $ atau # berarti berhasil masuk!**

---

## 🎬 LANGKAH 3: INSTALL DOCKER (Copy Paste Perintah)

**PENTING: Copy paste perintah satu per satu, tunggu selesai baru lanjut!**

### Perintah 1: Install Docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
```
⏱️ Tunggu 2-5 menit sampai selesai

### Perintah 2: Install Docker Compose
```bash
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
```
⏱️ Tunggu 1-2 menit

### Perintah 3: Cek Instalasi
```bash
docker --version && docker-compose --version
```
✅ Jika muncul versi Docker dan Docker Compose, berarti berhasil!

---

## 🎬 LANGKAH 4: SETUP DATABASE SUPABASE

### A. Buat Akun Supabase (Jika Belum Punya)
1. Buka https://supabase.com/
2. Klik **"Start your project"**
3. Sign up pakai akun Google/GitHub
4. Buat project baru (gratis)

### B. Buat Tabel Database
1. Di dashboard Supabase, klik **"SQL Editor"** (di menu kiri)
2. Klik **"+ New query"**
3. **Copy paste** kode ini ke editor:

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

-- Isi data awal (5 user untuk testing)
INSERT INTO users (id, name, email, role, status, password) VALUES
('1', 'Super Admin', 'admin@mail.com', 'admin', 'active', 'admin123'),
('2', 'Naila Selvira', 'naila@mail.com', 'employee', 'active', 'user123'),
('3', 'Budi Santoso', 'budi@mail.com', 'employee', 'active', 'user123'),
('4', 'Siti Aminah', 'siti@mail.com', 'employee', 'inactive', 'user123'),
('5', 'Andi Wijaya', 'andi@mail.com', 'employee', 'active', 'user123');
```

4. Klik tombol **"Run"** (atau tekan Ctrl + Enter)
5. Jika berhasil, akan muncul "Success. No rows returned"

✅ Database sudah siap!

---

## 🎬 LANGKAH 5: JALANKAN APLIKASI

**Masih di terminal SSH yang tadi, copy paste perintah ini satu per satu:**

### Perintah 1: Masuk ke Folder Aplikasi
```bash
cd /www/wwwroot/queenifyofficial.site
```

### Perintah 2: Siapkan File Environment
```bash
cp .env.production .env
```

### Perintah 3: Edit JWT Secret (PENTING!)
```bash
nano .env
```

Akan muncul editor teks. Cari baris:
```
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
```

**Ubah jadi** (atau random string apapun):
```
JWT_SECRET=RahasiaSayaSuperAman123456!@#$%
```

**Cara save:**
- Tekan `Ctrl + X`
- Tekan `Y`
- Tekan `Enter`

### Perintah 4: Jalankan Aplikasi! 🚀
```bash
docker-compose up -d --build
```

⏱️ **TUNGGU 5-10 MENIT** (Docker sedang build aplikasi)

### Perintah 5: Cek Status
```bash
docker-compose ps
```

✅ **Kalau muncul 2 container dengan status "Up", berarti BERHASIL!**

---

## 🎬 LANGKAH 6: SETTING DOMAIN DI AAPANEL

### A. Login ke aaPanel
1. Buka browser
2. Ketik: `http://[IP-SERVER]:7800`
3. Login dengan username & password aaPanel

### B. Tambah Website
1. Klik menu **"Website"** (di kiri)
2. Klik tombol **"Add site"** (di kanan atas)
3. Isi form:
   - **Domain**: `queenifyofficial.site` (tanpa http://)
   - Klik **"Add domain"** → tambahkan `www.queenifyofficial.site`
   - **Root directory**: `/www/wwwroot/queenifyofficial.site`
   - **PHP version**: Pilih "Pure static" atau "Don't set"
4. Klik **"Submit"**

### C. Setup Reverse Proxy (Backend API)

**PENTING: Ikuti langkah ini dengan teliti!**

1. Di daftar website, klik nama domain **"queenifyofficial.site"**
2. Klik tab **"Reverse proxy"** (atau "Proxy")
3. Klik tombol **"Add reverse proxy"**

**Isi form PERTAMA (untuk Backend):**
```
Proxy Name: Backend API
Target URL: http://127.0.0.1:3040
Proxy Directory: /api
```

4. Centang **"Enable proxy"**
5. Klik **"Submit"** atau **"Save"**

**Isi form KEDUA (untuk Frontend):**

6. Klik **"Add reverse proxy"** lagi
```
Proxy Name: Frontend
Target URL: http://127.0.0.1:3060
Proxy Directory: /
```

7. Centang **"Enable proxy"**
8. Klik **"Submit"** atau **"Save"**

### D. Install SSL Certificate (HTTPS)

1. Masih di setting website, klik tab **"SSL"**
2. Pilih **"Let's Encrypt"**
3. Centang domain `queenifyofficial.site` dan `www.queenifyofficial.site`
4. Klik tombol **"Apply"** atau **"Get certificate"**
5. ⏱️ Tunggu 1-2 menit
6. Setelah berhasil, aktifkan **"Force HTTPS"** (slider on)

✅ SSL sudah aktif!

---

## 🎉 LANGKAH 7: TEST WEBSITE

### A. Buka Website
1. Buka browser (Chrome/Firefox)
2. Ketik: `https://queenifyofficial.site`
3. Tunggu loading...

**✅ Harusnya muncul halaman LOGIN!**

### B. Test Login
Coba login dengan:
```
Email: admin@mail.com
Password: admin123
```

**Kalau berhasil masuk ke Dashboard → SELAMAT! APLIKASI SUDAH ONLINE! 🎊**

---

## ❌ KALAU ADA MASALAH

### Problem 1: Website Tidak Bisa Dibuka
**Solusi:**
1. Cek apakah domain sudah mengarah ke IP server
   - Buka https://dnschecker.org/
   - Ketik domain kamu
   - Pastikan semua mengarah ke IP server
   
2. Tunggu 1-24 jam (propagasi DNS)

### Problem 2: Login Gagal
**Solusi:**
1. Cek apakah database Supabase sudah dibuat (LANGKAH 4)
2. Pastikan data sudah di-insert
3. Coba perintah ini di SSH:
   ```bash
   docker-compose logs backend
   ```
4. Kirim screenshot error ke saya

### Problem 3: Container Tidak Jalan
**Solusi:**
```bash
# Restart semua
docker-compose down
docker-compose up -d --build

# Lihat error
docker-compose logs
```

---

## 🆘 BUTUH BANTUAN?

**Jika masih ada error, lakukan ini:**

1. **Screenshot** error yang muncul
2. Di SSH, jalankan:
   ```bash
   docker-compose logs > error.log
   cat error.log
   ```
3. Screenshot atau copy hasilnya
4. Kirim ke saya untuk dibantu

---

## 📞 KONTAK DARURAT

Jika benar-benar stuck:
1. Screenshot semua error
2. Jelaskan di langkah berapa stuck
3. Share screenshot terminal/browser

---

## ✅ CHECKLIST AKHIR

- [ ] FileZilla berhasil upload semua file
- [ ] SSH berhasil login ke server
- [ ] Docker & Docker Compose terinstall
- [ ] Database Supabase sudah dibuat & ada data
- [ ] File .env sudah diedit (JWT_SECRET)
- [ ] Docker container berjalan (docker-compose ps)
- [ ] Website ditambah di aaPanel
- [ ] Reverse proxy sudah disetup (backend & frontend)
- [ ] SSL certificate terinstall & Force HTTPS aktif
- [ ] Website bisa dibuka di browser
- [ ] Login berhasil dengan admin@mail.com

**Semua checklist centang? CONGRATULATIONS! 🎊🎉**

Website kamu sudah online di: **https://queenifyofficial.site**
