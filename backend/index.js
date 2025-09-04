const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express(); 

// Add CORS middleware
app.use(cors({
  origin: ['http://localhost:5051', 'http://127.0.0.1:5051', 'http://localhost:8080'],
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(express.json());

const mongoURI = process.env.MONGO_URI;
mongoose.connect(mongoURI)
    .then(() => console.log('Connect success MongoDB!'))
    .catch(err => console.error('Error connect MongoDB:', err));

app.get('/', (req, res) => {
    res.json({ message: 'API user' });
});

const userRoutes = require('./routes/user.routes');
app.use('/api/users', userRoutes);

const port = process.env.PORT || 5051;
app.listen(process.env.PORT || 5051, '0.0.0.0', () => {
  console.log('Server is listening at http://localhost:${port}');
});