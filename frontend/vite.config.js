import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3060,
    host: true,  // allow access from network
    proxy: {
      '/api': {
        target: 'http://localhost:3040',
        changeOrigin: true
      }
    }
  }
})
