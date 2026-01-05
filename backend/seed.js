const { supabase } = require('./src/data/supabaseClient');

const seedUsers = [
    { id: '1', name: 'Super Admin', email: 'admin@mail.com', role: 'admin', status: 'active', password: 'admin123' },
    { id: '2', name: 'Naila Selvira', email: 'naila@mail.com', role: 'employee', status: 'active', password: 'user123' },
    { id: '3', name: 'Budi Santoso', email: 'budi@mail.com', role: 'employee', status: 'active', password: 'user123' },
    { id: '4', name: 'Siti Aminah', email: 'siti@mail.com', role: 'employee', status: 'inactive', password: 'user123' },
    { id: '5', name: 'Andi Wijaya', email: 'andi@mail.com', role: 'employee', status: 'active', password: 'user123' }
];

async function seedDatabase() {
    console.log('🌱 Mulai seeding data...');

    // Insert users
    const { data, error } = await supabase
        .from('users')
        .upsert(seedUsers, { onConflict: 'id' });

    if (error) {
        console.error('❌ Error seeding:', error.message);
        console.log('\n📝 Pastikan tabel "users" sudah dibuat di Supabase dengan kolom:');
        console.log('   - id (text, primary key)');
        console.log('   - name (text)');
        console.log('   - email (text, unique)');
        console.log('   - role (text)');
        console.log('   - status (text)');
        console.log('   - password (text)');
        console.log('   - created_at (timestamp, default: now())');
    } else {
        console.log('✅ Berhasil seeding', seedUsers.length, 'users!');
        console.log('\n🔑 Credentials untuk login:');
        console.log('   Admin: admin@mail.com / admin123');
        console.log('   Employee: naila@mail.com / user123');
    }

    process.exit(0);
}

seedDatabase();
