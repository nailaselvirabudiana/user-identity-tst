# Script untuk Build & Push dari Komputer Lokal
# Jalankan di Windows PowerShell atau Git Bash

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "🏗️  BUILD & PUSH DOCKER IMAGE" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Konfigurasi (GANTI DENGAN USERNAME DOCKER HUB KAMU!)
$DOCKER_USERNAME = "noivira124"  # <-- GANTI INI!
$PROJECT_NAME = "user-identity-tst"
$BACKEND_IMAGE = "${DOCKER_USERNAME}/${PROJECT_NAME}-backend"
$FRONTEND_IMAGE = "${DOCKER_USERNAME}/${PROJECT_NAME}-frontend"
$VERSION = "latest"

Write-Host "📝 Konfigurasi:" -ForegroundColor Yellow
Write-Host "   Docker Hub User: $DOCKER_USERNAME" -ForegroundColor White
Write-Host "   Backend Image: $BACKEND_IMAGE" -ForegroundColor White
Write-Host "   Frontend Image: $FRONTEND_IMAGE" -ForegroundColor White
Write-Host ""

# 1. Cek apakah sudah login Docker
Write-Host "1️⃣  Cek Docker login..." -ForegroundColor Green
$loginCheck = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker tidak berjalan! Pastikan Docker Desktop sudah running." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Docker berjalan" -ForegroundColor Green
Write-Host ""

# 2. Login Docker Hub
Write-Host "2️⃣  Login ke Docker Hub..." -ForegroundColor Green
Write-Host "   Masukkan username & password Docker Hub kamu" -ForegroundColor Yellow
docker login
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Login gagal!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Login berhasil!" -ForegroundColor Green
Write-Host ""

# 3. Build Backend
Write-Host "3️⃣  Build Backend Image..." -ForegroundColor Green
Set-Location backend
docker build -t "${BACKEND_IMAGE}:${VERSION}" .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build backend gagal!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Backend image built!" -ForegroundColor Green
Set-Location ..
Write-Host ""

# 4. Build Frontend
Write-Host "4️⃣  Build Frontend Image..." -ForegroundColor Green
Set-Location frontend
docker build -t "${FRONTEND_IMAGE}:${VERSION}" .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build frontend gagal!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Frontend image built!" -ForegroundColor Green
Set-Location ..
Write-Host ""

# 5. Push Backend
Write-Host "5️⃣  Push Backend ke Docker Hub..." -ForegroundColor Green
docker push "${BACKEND_IMAGE}:${VERSION}"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Push backend gagal!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Backend pushed!" -ForegroundColor Green
Write-Host ""

# 6. Push Frontend
Write-Host "6️⃣  Push Frontend ke Docker Hub..." -ForegroundColor Green
docker push "${FRONTEND_IMAGE}:${VERSION}"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Push frontend gagal!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Frontend pushed!" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "🎉 BUILD & PUSH SELESAI!" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Images yang di-push:" -ForegroundColor Green
Write-Host "   $BACKEND_IMAGE`:$VERSION" -ForegroundColor White
Write-Host "   $FRONTEND_IMAGE`:$VERSION" -ForegroundColor White
Write-Host ""
Write-Host "📝 NEXT STEP:" -ForegroundColor Yellow
Write-Host "   1. Edit docker-compose.prod.yml" -ForegroundColor White
Write-Host "      Ganti 'yourusername' dengan: $DOCKER_USERNAME" -ForegroundColor White
Write-Host ""
Write-Host "   2. Upload docker-compose.prod.yml ke server" -ForegroundColor White
Write-Host ""
Write-Host "   3. Di server, jalankan:" -ForegroundColor White
Write-Host "      docker-compose -f docker-compose.prod.yml pull" -ForegroundColor Cyan
Write-Host "      docker-compose -f docker-compose.prod.yml up -d" -ForegroundColor Cyan
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
