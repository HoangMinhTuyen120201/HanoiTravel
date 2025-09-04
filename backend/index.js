const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();

const app = express(); 

app.use(express.json()); 

const mongoURI = process.env.MONGO_URI;
mongoose.connect(mongoURI)
    .then(() => console.log('Connect success MongoDB!'))
    .catch(err => console.error('Error connect MongoDB:', err));

app.get('/', (req, res) => {
    res.send('API user');
});

const userRoutes = require('./routes/user.routes');
app.use('/api/users', userRoutes);

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Server is listening at http://localhost:${port}`);
});