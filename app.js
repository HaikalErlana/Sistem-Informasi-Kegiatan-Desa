
const express = require('express');
const pool = require('./src/db');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// 1. GET: Menampilkan semua kegiatan
app.get('/api/kegiatan', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM kegiatan ORDER BY id_kegiatan ASC'
    );

    res.status(200).json({
      message: 'Data semua kegiatan berhasil diambil',
      data: result.rows,
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({
      message: 'Gagal mengambil data kegiatan',
    });
  }
});

// 2. GET: Menampilkan kegiatan berdasarkan ID
app.get('/api/kegiatan/:id', async (req, res) => {
  try {
    const { id } = req.params;

    if (!/^\d+$/.test(id) || Number(id) < 1) {
      return res.status(400).json({
        message: 'ID kegiatan harus berupa bilangan bulat positif',
      });
    }

    const result = await pool.query(
      'SELECT * FROM kegiatan WHERE id_kegiatan = $1',
      [Number(id)]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: 'Kegiatan tidak ditemukan',
      });
    }

    res.status(200).json({
      message: 'Data kegiatan berhasil ditemukan',
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({
      message: 'Gagal mengambil data kegiatan',
    });
  }
});

// 3. POST: Menambahkan kegiatan disimpan ke database
app.post('/api/kegiatan', async (req, res) => {
  try {
    const {
      id_kategori,
      id_lokasi,
      nama_kegiatan,
      deskripsi,
      tanggal_mulai,
      tanggal_selesai,
      status_kegiatan,
    } = req.body;

    if (
      !Number.isInteger(id_kategori) ||
      !Number.isInteger(id_lokasi) ||
      !nama_kegiatan ||
      !tanggal_mulai
    ) {
      return res.status(400).json({
        message: 'id_kategori, id_lokasi, nama_kegiatan, dan tanggal_mulai wajib diisi',
      });
    }

    const result = await pool.query(
      `INSERT INTO kegiatan
        (id_kategori, id_lokasi, nama_kegiatan, deskripsi,
         tanggal_mulai, tanggal_selesai, status_kegiatan)
       VALUES ($1, $2, $3, $4, $5, $6, COALESCE($7, 'direncanakan'))
       RETURNING *`,
      [
        id_kategori,
        id_lokasi,
        nama_kegiatan,
        deskripsi ?? null,
        tanggal_mulai,
        tanggal_selesai ?? null,
        status_kegiatan ?? null,
      ]
    );

    res.status(201).json({
      message: 'Kegiatan berhasil ditambahkan',
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error.message);

    if (error.code === '23503') {
      return res.status(400).json({
        message: 'ID kategori atau ID lokasi tidak ditemukan',
      });
    }

    if (error.code === '23514' || error.code === '22007') {
      return res.status(400).json({
        message: 'Status atau tanggal kegiatan tidak valid',
      });
    }

    res.status(500).json({
      message: 'Gagal menambahkan kegiatan',
    });
  }
});

// 4. PUT: Mengubah kegiatan berdasarkan ID
app.put('/api/kegiatan/:id', async (req, res) => {
  try {
    const { id } = req.params;

    if (!/^\d+$/.test(id) || Number(id) < 1) {
      return res.status(400).json({
        message: 'ID kegiatan harus berupa bilangan bulat positif',
      });
    }

    const {
      id_kategori,
      id_lokasi,
      nama_kegiatan,
      deskripsi,
      tanggal_mulai,
      tanggal_selesai,
      status_kegiatan,
    } = req.body;

    if (
      !Number.isInteger(id_kategori) ||
      !Number.isInteger(id_lokasi) ||
      !nama_kegiatan ||
      !tanggal_mulai
    ) {
      return res.status(400).json({
        message: 'id_kategori, id_lokasi, nama_kegiatan, dan tanggal_mulai wajib diisi',
      });
    }

    const result = await pool.query(
      `UPDATE kegiatan
       SET id_kategori = $1,
           id_lokasi = $2,
           nama_kegiatan = $3,
           deskripsi = $4,
           tanggal_mulai = $5,
           tanggal_selesai = $6,
           status_kegiatan = $7
       WHERE id_kegiatan = $8
       RETURNING *`,
      [
        id_kategori,
        id_lokasi,
        nama_kegiatan,
        deskripsi ?? null,
        tanggal_mulai,
        tanggal_selesai ?? null,
        status_kegiatan ?? 'direncanakan',
        Number(id),
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: 'Kegiatan tidak ditemukan',
      });
    }

    res.status(200).json({
      message: 'Kegiatan berhasil diperbarui',
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error.message);

    if (error.code === '23503') {
      return res.status(400).json({
        message: 'ID kategori atau ID lokasi tidak ditemukan',
      });
    }

    if (error.code === '23514' || error.code === '22007') {
      return res.status(400).json({
        message: 'Status atau tanggal kegiatan tidak valid',
      });
    }

    res.status(500).json({
      message: 'Gagal memperbarui kegiatan',
    });
  }
});

// 5. DELETE: Menghapus kegiatan berdasarkan ID
app.delete('/api/kegiatan/:id', async (req, res) => {
  try {
    const { id } = req.params;

    if (!/^\d+$/.test(id) || Number(id) < 1) {
      return res.status(400).json({
        message: 'ID kegiatan harus berupa bilangan bulat positif',
      });
    }

    const result = await pool.query(
      'DELETE FROM kegiatan WHERE id_kegiatan = $1 RETURNING *',
      [Number(id)]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: 'Kegiatan tidak ditemukan',
      });
    }

    res.status(200).json({
      message: 'Kegiatan berhasil dihapus',
      data: result.rows[0],
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({
      message: 'Gagal menghapus kegiatan',
    });
  }
});

// Menjalankan server
app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
