const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Health check - harus sebelum static files
app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'User Identity API is running' });
});

// API Routes
const usersRouter = require('./src/routes/users');
app.use('/api', usersRouter);

// Serve Frontend Static Files (Production)
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, 'frontend/dist')));
  
  // Handle React Router - semua route non-API ke index.html
  app.get('/{*splat}', (req, res) => {
    res.sendFile(path.join(__dirname, 'frontend/dist', 'index.html'));
  });
}

const PORT = process.env.PORT || 3040;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Mode: ${process.env.NODE_ENV || 'development'}`);
});
