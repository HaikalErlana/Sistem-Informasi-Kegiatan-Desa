const pool = require('./src/db');

async function testConnection() {
  try {
    const result = await pool.query(
      'SELECT current_database() AS database, current_user AS user'
    );

    console.log('Koneksi PostgreSQL berhasil!');
    console.log('Database:', result.rows[0].database);
    console.log('User:', result.rows[0].user);
  } catch (error) {
    console.error('Koneksi PostgreSQL gagal:', error.message);
  } finally {
    await pool.end();
  }
}

testConnection();