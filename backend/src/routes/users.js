const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const { supabase } = require("../data/supabaseClient");
const { auth, requireRole } = require("../middleware/auth");

// LOGIN
router.post("/auth/login", async (req, res) => {
    const { email, password } = req.body;
    const { data: user, error } = await supabase
        .from('users')
        .select('*')
        .eq('email', email)
        .single();

    if (error || !user || user.password !== String(password)) {
        return res.status(401).json({ message: "Invalid email or password" });
    }
    if (user.status !== "active") {
        return res.status(403).json({ message: "User is not active" });
    }

    // Generate JWT menggunakan secret key
    const token = jwt.sign(
        { user_id: user.id, role: user.role },
        process.env.JWT_SECRET || "secret123",
        { expiresIn: "2h" }
    );

    return res.json({
        token,
        user: { 
            id: user.id, 
            name: user.name, 
            role: user.role, 
            status: user.status 
        }
    });
});

// GET ALL USERS (Admin only)
router.get("/users", auth, requireRole(["admin"]), async (req, res) => {
    const { data, error } = await supabase
        .from('users')
        .select('id, name, email, role, status');

    if (error) return res.status(500).json({ message: error.message });
    return res.json(data);
});

// CREATE USER (Admin only)
router.post("/users", auth, requireRole(["admin"]), async (req, res) => {
    const { id, name, email, role, status, password } = req.body || {};
    
    if (!id || !name || !email) {
        return res.status(400).json({ message: "id, name, email are required" });
    }

    const { data, error } = await supabase
        .from('users')
        .insert([{
            id: String(id),
            name: String(name),
            email: String(email),
            role: role || "employee",
            status: status || "active",
            password: password || "user123"
        }])
        .select();

    if (error) return res.status(400).json({ message: error.message });
    return res.status(201).json(data[0]);
});

router.get("/users/:id", auth, async (req, res) => {
    const targetId = String(req.params.id);

    // Proteksi: Karyawan hanya bisa akses profil sendiri
    if (req.user.role !== "admin" && req.user.user_id !== targetId) {
        return res.status(403).json({ message: "Employees can only access their own profile" });
    }

    const { data, error } = await supabase
        .from('users')
        .select('*')
        .eq('id', targetId)
        .single();

    if (error || !data) return res.status(404).json({ message: "User not found" });
    return res.json(data);
});

router.patch("/users/:id", auth, async (req, res) => {
    const targetId = String(req.params.id);
    const { name, email } = req.body;

    if (req.user.role !== "admin" && req.user.user_id !== targetId) {
        return res.status(403).json({ message: "Forbidden" });
    }

    const updateData = {};
    if (name) updateData.name = name;
    if (email) updateData.email = email;

    const { data, error } = await supabase
        .from('users')
        .update(updateData)
        .eq('id', targetId)
        .select();

    if (error) return res.status(500).json({ message: error.message });
    if (!data.length) return res.status(404).json({ message: "User not found" });
    
    return res.json(data[0]);
});

router.patch("/users/:id/status", auth, requireRole(["admin"]), async (req, res) => {
    const { status } = req.body;
    const allowed = ["active", "inactive", "resigned"];
    
    if (!allowed.includes(String(status))) {
        return res.status(400).json({ message: "Invalid status" });
    }

    const { data, error } = await supabase
        .from('users')
        .update({ status: String(status) })
        .eq('id', req.params.id)
        .select();

    if (error) return res.status(500).json({ message: error.message });
    return res.json(data[0]);
});
module.exports = router;