#!/bin/bash

# Script untuk Pull & Run di Server
# Jalankan di server via SSH

echo "================================================"
echo "🚀 PULL & RUN DOCKER IMAGES"
echo "================================================"
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# 1. Cek Docker
echo "1️⃣  Cek Docker..."
if ! command -v docker &> /dev/null; then
    print_info "Docker belum terinstall. Installing..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    print_success "Docker terinstall!"
else
    print_success "Docker sudah ada"
fi

# 2. Cek Docker Compose
echo ""
echo "2️⃣  Cek Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    print_info "Docker Compose belum terinstall. Installing..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose terinstall!"
else
    print_success "Docker Compose sudah ada"
fi

# 3. Masuk ke direktori
echo ""
echo "3️⃣  Masuk ke direktori..."
cd /www/wwwroot/queenifyofficial.site
print_success "Di direktori aplikasi"

# 4. Setup environment
echo ""
echo "4️⃣  Setup environment..."
if [ -f ".env.production" ]; then
    cp .env.production .env
    print_success "Environment file ready"
    
    if ! grep -q "RahasiaSuperKuat" .env; then
        print_info "PENTING: Edit .env dan ganti JWT_SECRET!"
        print_info "Tekan ENTER untuk edit sekarang..."
        read
        nano .env
    fi
else
    print_error ".env.production tidak ditemukan!"
    exit 1
fi

# 5. Stop container lama
echo ""
echo "5️⃣  Stop container lama..."
docker-compose -f docker-compose.prod.yml down 2>/dev/null
print_success "Old containers stopped"

# 6. Pull images dari Docker Hub
echo ""
echo "6️⃣  Pull images dari Docker Hub..."
print_info "Ini akan download image yang sudah di-build di komputer lokal"
docker-compose -f docker-compose.prod.yml pull

if [ $? -eq 0 ]; then
    print_success "Images berhasil di-pull!"
else
    print_error "Pull gagal! Cek apakah images sudah di-push ke Docker Hub"
    exit 1
fi

# 7. Run containers
echo ""
echo "7️⃣  Menjalankan containers..."
docker-compose -f docker-compose.prod.yml up -d

if [ $? -eq 0 ]; then
    print_success "Containers running!"
else
    print_error "Failed to start containers!"
    exit 1
fi

# 8. Tunggu containers siap
echo ""
echo "8️⃣  Menunggu containers siap..."
sleep 10

# 9. Cek status
echo ""
echo "9️⃣  Status containers:"
docker-compose -f docker-compose.prod.yml ps

# 10. Test
echo ""
echo "🔟 Testing..."
sleep 5

backend_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3040/)
frontend_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/)

if [ "$backend_status" == "200" ]; then
    print_success "Backend running (HTTP $backend_status)"
else
    print_error "Backend not responding (HTTP $backend_status)"
fi

if [ "$frontend_status" == "200" ]; then
    print_success "Frontend running (HTTP $frontend_status)"
else
    print_error "Frontend not responding (HTTP $frontend_status)"
fi

# Summary
echo ""
echo "================================================"
echo "🎉 DEPLOY SELESAI!"
echo "================================================"
echo ""
print_info "Backend: http://localhost:3040"
print_info "Frontend: http://localhost:3000"
echo ""
print_info "Setup Reverse Proxy di aaPanel:"
echo "   /api → http://127.0.0.1:3040"
echo "   /    → http://127.0.0.1:3000"
echo ""
print_info "Perintah berguna:"
echo "   docker-compose -f docker-compose.prod.yml logs"
echo "   docker-compose -f docker-compose.prod.yml restart"
echo "   docker-compose -f docker-compose.prod.yml down"
echo ""
echo "================================================"
