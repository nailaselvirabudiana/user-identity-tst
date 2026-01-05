#!/bin/bash

# Script untuk Pull & Run FRONTEND ONLY di Server
# Jalankan di server via SSH

echo "================================================"
echo "🚀 PULL & RUN FRONTEND ONLY"
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
FRONTEND_IMAGE="${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:latest"

# 1. Stop & remove container frontend lama
echo "1️⃣  Stop container frontend lama..."
docker stop user-identity-frontend 2>/dev/null
docker rm user-identity-frontend 2>/dev/null
print_success "Old frontend container removed"

# 2. Pull image frontend terbaru
echo ""
echo "2️⃣  Pull frontend image dari Docker Hub..."
docker pull $FRONTEND_IMAGE
if [ $? -ne 0 ]; then
    print_error "Pull frontend gagal!"
    exit 1
fi
print_success "Frontend image berhasil di-pull!"

# 3. Cek network
echo ""
echo "3️⃣  Cek Docker network..."
docker network create app-network 2>/dev/null || print_info "Network sudah ada"
print_success "Network ready"

# 4. Run Frontend container
echo ""
echo "4️⃣  Run Frontend container..."
docker run -d \
  --name user-identity-frontend \
  --restart unless-stopped \
  -p 3060:80 \
  --network app-network \
  $FRONTEND_IMAGE

if [ $? -eq 0 ]; then
    print_success "Frontend container running!"
else
    print_error "Frontend failed to start!"
    docker logs user-identity-frontend
    exit 1
fi

# 5. Tunggu container siap
echo ""
echo "5️⃣  Menunggu container siap..."
sleep 5

# 6. Test
echo ""
echo "6️⃣  Testing frontend..."
frontend_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3060/)

if [ "$frontend_status" == "200" ]; then
    print_success "Frontend running (HTTP $frontend_status)"
else
    print_error "Frontend not responding (HTTP $frontend_status)"
fi

# Summary
echo ""
echo "================================================"
echo "🎉 FRONTEND DEPLOY SELESAI!"
echo "================================================"
echo ""
print_success "Frontend: http://localhost:3060"
echo ""
print_info "Perintah berguna:"
echo "   docker logs user-identity-frontend     # Lihat logs"
echo "   docker restart user-identity-frontend  # Restart"
echo "   docker stop user-identity-frontend     # Stop"
echo "   docker rm user-identity-frontend       # Remove"
echo ""
echo "================================================"
