# Stage 1: Build Frontend
FROM node:18-alpine AS frontend-builder

WORKDIR /app/frontend

# Copy frontend files
COPY frontend/package*.json ./
RUN npm install

COPY frontend/ ./
RUN npm run build

# Stage 2: Production Server
FROM node:18-alpine

WORKDIR /app

# Copy backend files
COPY package*.json ./
RUN npm install --production

COPY server.js ./
COPY src/ ./src/

# Copy frontend build dari stage 1
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# Environment
ENV NODE_ENV=production
ENV PORT=3040

EXPOSE 3040

CMD ["npm", "start"]
