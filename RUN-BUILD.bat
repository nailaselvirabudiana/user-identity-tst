@echo off
REM Build & Push Docker Images - All in One Batch Script
REM Ganti DOCKER_USERNAME dengan username Docker Hub kamu!

SET DOCKER_USERNAME=noivira124
SET PROJECT_NAME=user-identity-tst
SET BACKEND_IMAGE=%DOCKER_USERNAME%/%PROJECT_NAME%-backend
SET FRONTEND_IMAGE=%DOCKER_USERNAME%/%PROJECT_NAME%-frontend
SET VERSION=latest

echo ================================================
echo BUILD ^& PUSH DOCKER IMAGE
echo ================================================
echo.
echo Konfigurasi:
echo    Docker Hub User: %DOCKER_USERNAME%
echo    Backend Image: %BACKEND_IMAGE%:%VERSION%
echo    Frontend Image: %FRONTEND_IMAGE%:%VERSION%
echo.

REM 1. Cek Docker
echo 1. Cek Docker berjalan...
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker tidak berjalan! Pastikan Docker Desktop sudah running.
    pause
    exit /b 1
)
echo [OK] Docker berjalan
echo.

REM 2. Login Docker Hub
echo 2. Login ke Docker Hub...
echo    Masukkan username dan password Docker Hub kamu
docker login
if errorlevel 1 (
    echo [ERROR] Login gagal!
    pause
    exit /b 1
)
echo [OK] Login berhasil!
echo.

REM 3. Setup buildx untuk multi-platform
echo 3. Setup Docker Buildx untuk multi-platform...
docker buildx create --name multibuilder --use 2>nul
docker buildx inspect --bootstrap
echo [OK] Buildx ready!
echo.

REM 4. Build Backend (Multi-platform: AMD64 + ARM64)
echo 4. Build Backend Image untuk AMD64 ^& ARM64...
cd backend
docker buildx build --platform linux/amd64,linux/arm64 -t %BACKEND_IMAGE%:%VERSION% --push .
if errorlevel 1 (
    echo [ERROR] Build backend gagal!
    cd ..
    pause
    exit /b 1
)
echo [OK] Backend image built ^& pushed!
cd ..
echo.

REM 5. Build Frontend (Multi-platform: AMD64 + ARM64)
echo 5. Build Frontend Image untuk AMD64 ^& ARM64...
cd frontend
docker buildx build --platform linux/amd64,linux/arm64 -t %FRONTEND_IMAGE%:%VERSION% --push .
if errorlevel 1 (
    echo [ERROR] Build frontend gagal!
    cd ..
    pause
    exit /b 1
)
echo [OK] Frontend image built ^& pushed!
cd ..
echo.

REM Summary
echo ================================================
echo BUILD ^& PUSH SELESAI!
echo ================================================
echo.
echo Images yang di-push:
echo    %BACKEND_IMAGE%:%VERSION%
echo    %FRONTEND_IMAGE%:%VERSION%
echo.
echo NEXT STEP:
echo    1. Edit docker-compose.prod.yml
echo       Ganti 'yourusername' dengan: %DOCKER_USERNAME%
echo.
echo    2. Upload docker-compose.prod.yml ke server
echo.
echo    3. Di server, jalankan:
echo       docker-compose -f docker-compose.prod.yml pull
echo       docker-compose -f docker-compose.prod.yml up -d
echo.
echo ================================================
pause
