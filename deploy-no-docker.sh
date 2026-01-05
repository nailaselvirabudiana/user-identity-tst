#!/bin/bash

# Script Deploy TANPA Docker (Lebih Ringan untuk Server Kecil)
# Cocok jika Docker error atau server memory terbatas

echo "================================================"
echo "🚀 DEPLOY MANUAL (TANPA DOCKER)"
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

# 1. Cek Node.js
echo "1️⃣  Cek Node.js..."
if ! command -v node &> /dev/null; then
    print_info "Node.js belum terinstall. Installing..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
    print_success "Node.js terinstall!"
else
    print_success "Node.js sudah ada: $(node --version)"
fi

# 2. Cek npm
if ! command -v npm &> /dev/null; then
    print_error "npm tidak ditemukan!"
    exit 1
fi

# 3. Install PM2 (Process Manager)
echo ""
echo "2️⃣  Install PM2..."
if ! command -v pm2 &> /dev/null; then
    npm install -g pm2
    print_success "PM2 terinstall!"
else
    print_success "PM2 sudah ada"
fi

# 4. Setup Backend
echo ""
echo "3️⃣  Setup Backend..."
cd /www/wwwroot/queenifyofficial.site/backend

# Install dependencies
print_info "Installing backend dependencies..."
npm install
print_success "Backend dependencies installed!"

# Copy environment
if [ -f "../.env.production" ]; then
    cp ../.env.production .env
    print_success "Environment file copied"
fi

# 5. Build Frontend
echo ""
echo "4️⃣  Build Frontend..."
cd /www/wwwroot/queenifyofficial.site/frontend

# Install dependencies
print_info "Installing frontend dependencies..."
npm install
print_success "Frontend dependencies installed!"

# Build production
print_info "Building frontend... (ini akan lama, ~5 menit)"
npm run build
print_success "Frontend built!"

# 6. Stop proses lama (jika ada)
echo ""
echo "5️⃣  Membersihkan proses lama..."
pm2 delete backend 2>/dev/null
pm2 delete all 2>/dev/null
print_success "Old processes cleaned"

# 7. Start Backend dengan PM2
echo ""
echo "6️⃣  Menjalankan Backend..."
cd /www/wwwroot/queenifyofficial.site/backend
pm2 start npm --name "backend" -- start
pm2 save
print_success "Backend started with PM2!"

# 8. Setup Frontend di aaPanel
echo ""
echo "7️⃣  Setup Frontend..."
print_info "Frontend sudah di-build di folder: /www/wwwroot/queenifyofficial.site/frontend/dist"

# Summary
echo ""
echo "================================================"
echo "🎉 DEPLOY SELESAI (TANPA DOCKER)!"
echo "================================================"
echo ""
print_success "Backend berjalan di: http://localhost:3040"
print_success "Frontend ada di: /www/wwwroot/queenifyofficial.site/frontend/dist"
echo ""
print_info "LANGKAH SELANJUTNYA DI AAPANEL:"
echo ""
echo "1. BACKEND PROXY:"
echo "   Website → queenifyofficial.site → Reverse Proxy"
echo "   Add proxy:"
echo "   - Name: Backend API"
echo "   - URL: http://127.0.0.1:3040"
echo "   - Directory: /api"
echo ""
echo "2. FRONTEND (ROOT):"
echo "   Website → queenifyofficial.site → Site directory"
echo "   Ganti ke: /www/wwwroot/queenifyofficial.site/frontend/dist"
echo ""
echo "3. SSL Certificate:"
echo "   SSL → Let's Encrypt → Apply"
echo ""
print_info "Perintah berguna:"
echo "   pm2 status         - Lihat status backend"
echo "   pm2 logs backend   - Lihat logs"
echo "   pm2 restart backend - Restart backend"
echo "   pm2 stop backend   - Stop backend"
echo ""
echo "================================================"
