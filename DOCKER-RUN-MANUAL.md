# 🐳 Perintah Docker Run Manual

Jika tidak mau pakai docker-compose, gunakan perintah manual ini:

---

## 📋 Persiapan

```bash
# Masuk ke folder
cd /www/wwwroot/queenifyofficial.site

# Setup environment
cp .env.production .env
nano .env  # Edit JWT_SECRET
```

---

## 🚀 Jalankan dengan Script

```bash
chmod +x docker-run-manual.sh
./docker-run-manual.sh
```

---

## 🛠️ Atau Manual Step-by-Step:

### 1. Buat Network
```bash
docker network create app-network
```

### 2. Pull Images
```bash
docker pull noivira124/user-identity-tst-backend:latest
docker pull noivira124/user-identity-tst-frontend:latest
```

### 3. Run Backend
```bash
docker run -d \
  --name user-identity-backend \
  --restart unless-stopped \
  -p 3040:3040 \
  -e NODE_ENV=production \
  -e SUPABASE_URL="https://oztedaqnfhoremobeyfi.supabase.co" \
  -e SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96dGVkYXFuZmhvcmVtb2JleWZpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc2MTY3NjUsImV4cCI6MjA4MzE5Mjc2NX0.2rZl_9dk43KtiVDfLdwY2B6xdR84kJjGQ1xVvU0zRbU" \
  -e SUPABASE_SERVICE_ROLE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96dGVkYXFuZmhvcmVtb2JleWZpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzYxNjc2NSwiZXhwIjoyMDgzMTkyNzY1fQ.9_wmfSMO5-5LHSBMNqFwRUGR27Y2K4E5DSf6vbAHXmg" \
  -e JWT_SECRET="GantiDenganStringRandomKamu123!@#$%" \
  -e PORT=3040 \
  --network app-network \
  noivira124/user-identity-tst-backend:latest
```

### 4. Run Frontend
```bash
docker run -d \
  --name user-identity-frontend \
  --restart unless-stopped \
  -p 3060:80 \
  --network app-network \
  noivira124/user-identity-tst-frontend:latest
```

### 5. Cek Status
```bash
docker ps
```

### 6. Test
```bash
curl http://localhost:3040/
curl http://localhost:3000/
```

---

## 🔧 Perintah Berguna

```bash
# Lihat logs
docker logs user-identity-backend
docker logs user-identity-frontend

# Follow logs (real-time)
docker logs -f user-identity-backend

# Restart
docker restart user-identity-backend
docker restart user-identity-frontend

# Stop
docker stop user-identity-backend user-identity-frontend

# Remove
docker rm user-identity-backend user-identity-frontend

# Remove & Run ulang
docker stop user-identity-backend user-identity-frontend
docker rm user-identity-backend user-identity-frontend
# Lalu jalankan docker run lagi dari langkah 3-4
```

---

## 🔄 Update Image (Pull versi baru)

```bash
# Stop container
docker stop user-identity-backend user-identity-frontend

# Remove container lama
docker rm user-identity-backend user-identity-frontend

# Pull image terbaru
docker pull noivira124/user-identity-tst-backend:latest
docker pull noivira124/user-identity-tst-frontend:latest

# Run ulang (perintah di langkah 3-4)
```

---

## 📝 Catatan

**Kelebihan `docker run` manual:**
- ✅ Lebih control detail
- ✅ Tidak perlu docker-compose file
- ✅ Bisa custom per container

**Kekurangan:**
- ❌ Perintah panjang
- ❌ Harus manual stop/start semua container
- ❌ Environment variable harus diketik manual

**Rekomendasi:** Pakai `docker-compose` lebih praktis! 😊
