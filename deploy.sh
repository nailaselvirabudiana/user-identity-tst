#!/bin/bash

# Script Otomatis Deploy untuk Pemula
# Jalankan script ini setelah upload file ke server

echo "================================================"
echo "🚀 MULAI DEPLOY APLIKASI USER IDENTITY"
echo "================================================"
echo ""

# Warna untuk output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fungsi untuk print dengan warna
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# 1. Cek apakah Docker sudah terinstall
echo "1️⃣  Mengecek Docker..."
if ! command -v docker &> /dev/null; then
    print_info "Docker belum terinstall. Sedang menginstall..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    print_success "Docker berhasil diinstall!"
else
    print_success "Docker sudah terinstall"
fi

# 2. Cek Docker Compose
echo ""
echo "2️⃣  Mengecek Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    print_info "Docker Compose belum terinstall. Sedang menginstall..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose berhasil diinstall!"
else
    print_success "Docker Compose sudah terinstall"
fi

# 3. Masuk ke direktori aplikasi
echo ""
echo "3️⃣  Masuk ke direktori aplikasi..."
if [ -d "/www/wwwroot/queenifyofficial.site" ]; then
    cd /www/wwwroot/queenifyofficial.site
    print_success "Direktori ditemukan"
else
    print_error "Direktori /www/wwwroot/queenifyofficial.site tidak ditemukan!"
    print_info "Pastikan Anda sudah upload file via FileZilla"
    exit 1
fi

# 4. Copy file environment
echo ""
echo "4️⃣  Setup environment variables..."
if [ -f ".env.production" ]; then
    cp .env.production .env
    print_success "File .env berhasil dibuat"
    
    print_info "PENTING: Edit file .env dan ganti JWT_SECRET!"
    print_info "Jalankan: nano .env"
    print_info "Ganti JWT_SECRET dengan string random, lalu save (Ctrl+X, Y, Enter)"
    echo ""
    read -p "Sudah edit JWT_SECRET? (y/n): " jawaban
    if [ "$jawaban" != "y" ]; then
        print_error "Silakan edit .env terlebih dahulu!"
        nano .env
    fi
else
    print_error "File .env.production tidak ditemukan!"
    exit 1
fi

# 5. Hentikan container yang sedang berjalan (jika ada)
echo ""
echo "5️⃣  Membersihkan container lama (jika ada)..."
docker-compose down 2>/dev/null
print_success "Container lama dihapus"

# 6. Build dan jalankan container
echo ""
echo "6️⃣  Build dan menjalankan aplikasi..."
print_info "Proses ini akan memakan waktu 5-10 menit. Mohon sabar..."
echo ""

docker-compose up -d --build

if [ $? -eq 0 ]; then
    print_success "Build berhasil!"
else
    print_error "Build gagal! Cek error di atas."
    exit 1
fi

# 7. Tunggu container siap
echo ""
echo "7️⃣  Menunggu container siap..."
sleep 10

# 8. Cek status container
echo ""
echo "8️⃣  Mengecek status container..."
docker-compose ps

# 9. Test backend
echo ""
echo "9️⃣  Testing backend API..."
sleep 5
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3040/)
if [ "$response" == "200" ]; then
    print_success "Backend berjalan dengan baik!"
else
    print_error "Backend tidak merespon (HTTP $response)"
fi

# 10. Test frontend
echo ""
echo "🔟 Testing frontend..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/)
if [ "$response" == "200" ]; then
    print_success "Frontend berjalan dengan baik!"
else
    print_error "Frontend tidak merespon (HTTP $response)"
fi

# Summary
echo ""
echo "================================================"
echo "🎉 DEPLOY SELESAI!"
echo "================================================"
echo ""
print_success "Backend: http://localhost:3040"
print_success "Frontend: http://localhost:3000"
echo ""
print_info "LANGKAH SELANJUTNYA:"
echo "1. Setup Reverse Proxy di aaPanel"
echo "   - Backend: /api → http://127.0.0.1:3040"
echo "   - Frontend: / → http://127.0.0.1:3000"
echo ""
echo "2. Install SSL Certificate di aaPanel"
echo ""
echo "3. Buka https://queenifyofficial.site"
echo ""
echo "4. Login dengan:"
echo "   Email: admin@mail.com"
echo "   Password: admin123"
echo ""
print_info "Untuk melihat logs:"
echo "   docker-compose logs -f"
echo ""
print_info "Untuk restart:"
echo "   docker-compose restart"
echo ""
print_info "Untuk stop:"
echo "   docker-compose down"
echo ""
echo "================================================"
