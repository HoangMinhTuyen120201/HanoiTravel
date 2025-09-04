const express = require('express');
const router = express.Router();
const User = require('../models/user.model');
const jwt = require('jsonwebtoken');

// GET all users
router.get('/', async (req, res) => {
    try {
        const users = await User.find().select('-password');
        res.json(users);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// POST: Register new user
router.post('/register', async (req, res) => {
    console.log('Register request received:', req.body);
    try {
        const { firstName, lastName, email, password, phone, birthDate, gender } = req.body;

        console.log('Extracted data:', { firstName, lastName, email, password: '***', phone, birthDate, gender });

        // Check if user already exists
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            console.log('User already exists with email:', email);
            return res.status(400).json({ message: 'Email đã được sử dụng' });
        }

        // Validate required fields
        if (!firstName || !lastName || !email || !password || !phone || !birthDate || !gender) {
            console.log('Missing required fields');
            return res.status(400).json({ message: 'Vui lòng điền đầy đủ thông tin' });
        }

        // Validate password length
        if (password.length < 6) {
            console.log('Password too short');
            return res.status(400).json({ message: 'Mật khẩu phải có ít nhất 6 ký tự' });
        }

        console.log('Creating new user...');
        // Create new user
        const user = new User({
            firstName,
            lastName,
            email,
            password,
            phone,
            birthDate: new Date(birthDate),
            gender
        });

        const newUser = await user.save();
        console.log('User saved successfully:', newUser._id);

        // Remove password from response
        const userResponse = newUser.toObject();
        delete userResponse.password;

        console.log('Sending response...');
        res.status(201).json({
            message: 'Đăng ký thành công',
            user: userResponse
        });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(400).json({ message: error.message });
    }
});

// POST: Login user
router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        // Validate required fields
        if (!email || !password) {
            return res.status(400).json({ message: 'Email và mật khẩu là bắt buộc' });
        }

        // Check if user exists
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(401).json({ message: 'Email hoặc mật khẩu không đúng' });
        }

        // Check password
        const isPasswordValid = await user.comparePassword(password);
        if (!isPasswordValid) {
            return res.status(401).json({ message: 'Email hoặc mật khẩu không đúng' });
        }

        // Generate JWT token (optional)
        const token = jwt.sign(
            { userId: user._id, email: user.email },
            process.env.JWT_SECRET || 'your_jwt_secret',
            { expiresIn: '7d' }
        );

        // Remove password from response
        const userResponse = user.toObject();
        delete userResponse.password;

        res.json({
            message: 'Đăng nhập thành công',
            user: userResponse,
            token
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// GET: Get user by ID
router.get('/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id).select('-password');
        if (!user) {
            return res.status(404).json({ message: 'Không tìm thấy người dùng' });
        }
        res.json(user);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// PUT: Update user
router.put('/:id', async (req, res) => {
    try {
        const { firstName, lastName, phone, birthDate, gender } = req.body;

        const user = await User.findById(req.params.id);
        if (!user) {
            return res.status(404).json({ message: 'Không tìm thấy người dùng' });
        }

        // Update fields
        if (firstName) user.firstName = firstName;
        if (lastName) user.lastName = lastName;
        if (phone) user.phone = phone;
        if (birthDate) user.birthDate = new Date(birthDate);
        if (gender) user.gender = gender;

        const updatedUser = await user.save();

        // Remove password from response
        const userResponse = updatedUser.toObject();
        delete userResponse.password;

        res.json({
            message: 'Cập nhật thành công',
            user: userResponse
        });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// DELETE: Delete user
router.delete('/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) {
            return res.status(404).json({ message: 'Không tìm thấy người dùng' });
        }

        await User.findByIdAndDelete(req.params.id);
        res.json({ message: 'Xóa người dùng thành công' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;