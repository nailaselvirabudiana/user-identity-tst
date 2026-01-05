# 🆘 SOLUSI: Segmentation Fault di Docker

## ❌ Masalah: Segmentation Fault

Ini terjadi karena:
- Server memory terlalu kecil untuk Docker
- Docker build memakan banyak resource
- Container crash saat startup

---

## ✅ SOLUSI 1: Deploy TANPA Docker (PALING MUDAH)

### Jalankan script alternatif:

```bash
cd /www/wwwroot/queenifyofficial.site
chmod +x deploy-no-docker.sh
./deploy-no-docker.sh
```

Script ini akan:
- ✅ Install Node.js & PM2
- ✅ Install dependencies backend
- ✅ Build frontend
- ✅ Jalankan backend dengan PM2 (lebih ringan)
- ✅ Tidak pakai Docker sama sekali

⏱️ Tunggu 5-10 menit

### Setelah selesai, setup di aaPanel:

**1. Backend Reverse Proxy:**
- Website → queenifyofficial.site → Reverse Proxy
- Add proxy:
  ```
  Name: Backend API
  Target URL: http://127.0.0.1:3040
  Proxy directory: /api
  ```

**2. Frontend Root Directory:**
- Website → queenifyofficial.site → Site directory
- Ganti ke: `/www/wwwroot/queenifyofficial.site/frontend/dist`

**3. SSL:**
- SSL → Let's Encrypt → Apply

---

## ✅ SOLUSI 2: Fix Docker (Jika Mau Pakai Docker)

### A. Increase Memory Limit

Edit file docker-compose.yml:

```bash
nano docker-compose.yml
```

Tambahkan memory limit:

```yaml
services:
  backend:
    # ... existing config
    mem_limit: 512m
    
  frontend:
    # ... existing config
    mem_limit: 1g
```

### B. Build One by One (Tidak Sekaligus)

```bash
# Stop semua
docker-compose down

# Build backend dulu
docker-compose build backend

# Tunggu selesai, baru build frontend
docker-compose build frontend

# Jalankan
docker-compose up -d
```

### C. Cek Logs Error

```bash
# Lihat error detail
docker-compose logs

# Atau per service
docker-compose logs backend
docker-compose logs frontend
```

---

## ✅ SOLUSI 3: Manual Deploy (Step by Step)

### 1. Install Node.js
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
```

### 2. Install PM2
```bash
npm install -g pm2
```

### 3. Setup Backend
```bash
cd /www/wwwroot/queenifyofficial.site/backend
npm install
cp ../.env.production .env

# Edit JWT_SECRET di .env
nano .env

# Jalankan dengan PM2
pm2 start npm --name backend -- start
pm2 save
pm2 startup
```

### 4. Build Frontend
```bash
cd /www/wwwroot/queenifyofficial.site/frontend
npm install
npm run build
```

### 5. Setup di aaPanel
Sama seperti Solusi 1 di atas.

---

## 📊 Cek Resource Server

```bash
# Cek memory
free -h

# Cek CPU
top

# Jika memory < 1GB, pakai deploy-no-docker.sh
# Jika memory > 2GB, Docker harusnya bisa
```

---

## 🎯 REKOMENDASI SAYA:

**Pakai Solusi 1 (deploy-no-docker.sh)** karena:
- ✅ Lebih ringan
- ✅ Lebih cepat
- ✅ Tidak perlu Docker
- ✅ PM2 lebih stabil untuk server kecil
- ✅ Lebih mudah debug

---

## 🆘 Kalau Masih Error?

Kirim output dari:
```bash
# Info system
free -h
df -h

# Cek error
pm2 logs
```
