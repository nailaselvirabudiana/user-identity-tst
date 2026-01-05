#!/bin/bash
# Manual Docker Run (Tanpa Docker Compose)
# Jalankan di server via SSH

echo "================================================"
echo "🐳 MANUAL DOCKER RUN"
echo "================================================"
echo ""

# 1. Buat network
echo "1. Membuat Docker network..."
docker network create app-network 2>/dev/null || echo "Network sudah ada"

# 2. Pull images
echo ""
echo "2. Pull images dari Docker Hub..."
docker pull noivira124/user-identity-tst-backend:latest
docker pull noivira124/user-identity-tst-frontend:latest

# 3. Stop & remove container lama (jika ada)
echo ""
echo "3. Cleanup container lama..."
docker stop user-identity-backend user-identity-frontend 2>/dev/null
docker rm user-identity-backend user-identity-frontend 2>/dev/null

# 4. Load environment variables
echo ""
echo "4. Load environment variables..."
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo "✅ Environment loaded"
else
    echo "❌ File .env tidak ditemukan!"
    exit 1
fi

# 5. Run Backend
echo ""
echo "5. Run Backend container..."
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
  noivira124/user-identity-tst-backend:latest

if [ $? -eq 0 ]; then
    echo "✅ Backend running!"
else
    echo "❌ Backend failed!"
    exit 1
fi

# 6. Run Frontend
echo ""
echo "6. Run Frontend container..."
docker run -d \
  --name user-identity-frontend \
  --restart unless-stopped \
  -p 3000:80 \
  --network app-network \
  noivira124/user-identity-tst-frontend:latest

if [ $? -eq 0 ]; then
    echo "✅ Frontend running!"
else
    echo "❌ Frontend failed!"
    exit 1
fi

# 7. Cek status
echo ""
echo "7. Status containers:"
docker ps | grep user-identity

# 8. Test
echo ""
echo "8. Testing..."
sleep 5
curl -s http://localhost:3040/ | grep -q "running" && echo "✅ Backend OK" || echo "❌ Backend NOT responding"
curl -s http://localhost:3000/ > /dev/null && echo "✅ Frontend OK" || echo "❌ Frontend NOT responding"

echo ""
echo "================================================"
echo "✅ DEPLOY SELESAI!"
echo "================================================"
echo ""
echo "Backend: http://localhost:3040"
echo "Frontend: http://localhost:3000"
echo ""
echo "Perintah berguna:"
echo "  docker logs user-identity-backend   # Lihat logs backend"
echo "  docker logs user-identity-frontend  # Lihat logs frontend"
echo "  docker restart user-identity-backend"
echo "  docker restart user-identity-frontend"
echo "  docker stop user-identity-backend user-identity-frontend"
echo "  docker rm user-identity-backend user-identity-frontend"
echo ""
