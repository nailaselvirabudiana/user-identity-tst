#!/bin/bash

# Script untuk Pull & Run di Server (Tanpa Docker Compose)
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

# Config
DOCKER_USERNAME="noivira124"
PROJECT_NAME="user-identity-tst"
BACKEND_IMAGE="${DOCKER_USERNAME}/${PROJECT_NAME}-backend:latest"
FRONTEND_IMAGE="${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:latest"

# 1. Cek Docker
echo "1️⃣  Cek Docker..."
if ! command -v docker &> /dev/null; then
    print_info "Docker belum terinstall. Installing..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    print_success "Docker terinstall!"
else
    print_success "Docker sudah ada"
fi

# 2. Masuk ke direktori
echo ""
echo "2️⃣  Masuk ke direktori..."
cd /www/wwwroot/queenifyofficial.site
print_success "Di direktori aplikasi"

# 3. Setup environment
echo ""
echo "3️⃣  Setup environment..."
if [ -f ".env.production" ]; then
    cp .env.production .env
    print_success "Environment file ready"
    
    if ! grep -q "RahasiaSuperKuat" .env; then
        print_info "PENTING: Edit .env dan ganti JWT_SECRET!"
        print_info "Tekan ENTER untuk edit sekarang atau CTRL+C untuk skip..."
        read
        nano .env
    fi
    
    # Load environment variables
    export $(cat .env | grep -v '^#' | xargs)
    print_success "Environment loaded"
else
    print_error ".env.production tidak ditemukan!"
    exit 1
fi

# 4. Buat network
echo ""
echo "4️⃣  Buat Docker network..."
docker network create app-network 2>/dev/null || print_info "Network sudah ada"
print_success "Network ready"

# 5. Stop & remove container lama
echo ""
echo "5️⃣  Stop container lama..."
docker stop user-identity-backend user-identity-frontend 2>/dev/null
docker rm user-identity-backend user-identity-frontend 2>/dev/null
print_success "Old containers removed"

# 6. Pull images dari Docker Hub
echo ""
echo "6️⃣  Pull images dari Docker Hub..."
print_info "Downloading backend..."
docker pull $BACKEND_IMAGE
if [ $? -ne 0 ]; then
    print_error "Pull backend gagal!"
    exit 1
fi

print_info "Downloading frontend..."
docker pull $FRONTEND_IMAGE
if [ $? -ne 0 ]; then
    print_error "Pull frontend gagal!"
    exit 1
fi

print_success "Images berhasil di-pull!"

# 7. Run Backend
echo ""
echo "7️⃣  Run Backend container..."
docker run -d \
  --name user-identity-backend \
  --restart unless-stopped \
  -p 3040:3040 \
  -e NODE_ENV=production \
  -e SUPABASE_URL="$SUPABASE_URL" \
  -e SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
  -e SUPABASE_SERVICE_ROLE_KEY="$SUPABASE_SERVICE_ROLE_KEY" \
  -e JWT_SECRET="$JWT_SECRET" \
  -e PORT=3040 \
  --network app-network \
  $BACKEND_IMAGE

if [ $? -eq 0 ]; then
    print_success "Backend container running!"
else
    print_error "Backend failed to start!"
    docker logs user-identity-backend
    exit 1
fi

# 8. Run Frontend
echo ""
echo "8️⃣  Run Frontend container..."
docker run -d \
  --name user-identity-frontend \
  --restart unless-stopped \
  -p 3000:80 \
  --network app-network \
  $FRONTEND_IMAGE

if [ $? -eq 0 ]; then
    print_success "Frontend container running!"
else
    print_error "Frontend failed to start!"
    docker logs user-identity-frontend
    exit 1
fi

# 9. Tunggu containers siap
echo ""
echo "9️⃣  Menunggu containers siap..."
sleep 10

# 10. Cek status
echo ""
echo "🔟 Status containers:"
docker ps | grep user-identity

# 11. Test
echo ""
echo "1️⃣1️⃣  Testing..."
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
print_success "Backend: http://localhost:3040"
print_success "Frontend: http://localhost:3000"
echo ""
print_info "Setup Reverse Proxy di aaPanel:"
echo "   /api → http://127.0.0.1:3040"
echo "   /    → http://127.0.0.1:3000"
echo ""
print_info "Perintah berguna:"
echo "   docker logs user-identity-backend      # Lihat logs"
echo "   docker logs user-identity-frontend"
echo "   docker restart user-identity-backend   # Restart"
echo "   docker restart user-identity-frontend"
echo "   docker stop user-identity-backend user-identity-frontend"
echo "   docker rm user-identity-backend user-identity-frontend"
echo ""
echo "================================================"
