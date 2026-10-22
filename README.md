# Sistem Informasi Kegiatan Desa

REST API untuk mengelola data kegiatan masyarakat desa menggunakan Express.js dan PostgreSQL.

## 1. Deskripsi Proyek

Sistem Informasi Kegiatan Desa dirancang untuk membantu pengelolaan data kegiatan masyarakat desa. API ini menyediakan fitur untuk menampilkan, menambahkan, memperbarui, dan menghapus data kegiatan.

## 2. Teknologi yang Digunakan

- Node.js
- Express.js
- PostgreSQL
- node-postgres (`pg`)
- dotenv
- Postman untuk pengujian API

## 3. Struktur Proyek

```text
sistem-informasi-kegiatan-desa/
├── src/
│   └── db.js
├── app.js
├── database.sql
├── database_export.sql
├── package.json
├── package-lock.json
├── test-db.js
├── .gitignore
└── README.md
```

## 4. Database

Nama database: `db_kegiatan_desa`

Database memiliki sembilan tabel:

1. `warga`
2. `kategori_kegiatan`
3. `lokasi`
4. `kegiatan`
5. `jadwal_kegiatan`
6. `pendaftaran`
7. `panitia`
8. `dokumentasi_kegiatan`
9. `kehadiran`

File SQL untuk struktur database tersedia pada repository ini.

## 5. Persiapan dan Instalasi

Pastikan Node.js dan PostgreSQL sudah terpasang.

### Instalasi dependensi

```bash
npm install
```

### Konfigurasi environment

Buat file `.env` pada folder utama proyek dan isi dengan konfigurasi database lokal:

```dotenv
DB_HOST=localhost
DB_PORT=5432
DB_NAME=db_kegiatan_desa
DB_USER=isi_username_postgresql
DB_PASSWORD=isi_password_postgresql
PORT=3000
```

Ganti username dan password dengan kredensial PostgreSQL milikmu. Jangan mengunggah file `.env` ke GitHub.

### Menjalankan aplikasi

```bash
npm run dev
```

Server berjalan pada:

`http://localhost:3000`

## 6. Dokumentasi Endpoint API

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/api/kegiatan` | Menampilkan semua kegiatan |
| GET | `/api/kegiatan/:id` | Menampilkan kegiatan berdasarkan ID |
| POST | `/api/kegiatan` | Menambahkan kegiatan |
| PUT | `/api/kegiatan/:id` | Memperbarui kegiatan berdasarkan ID |
| DELETE | `/api/kegiatan/:id` | Menghapus kegiatan berdasarkan ID |

### Contoh body untuk POST dan PUT

```json
{
  "id_kategori": 1,
  "id_lokasi": 1,
  "nama_kegiatan": "Kerja Bakti Desa",
  "deskripsi": "Kegiatan gotong royong membersihkan lingkungan desa",
  "tanggal_mulai": "2026-11-01",
  "tanggal_selesai": "2026-11-01",
  "status_kegiatan": "direncanakan"
}
```

Status kegiatan yang didukung:

- `direncanakan`
- `berlangsung`
- `selesai`
- `dibatalkan`

## 7. Pengujian API

Pengujian dilakukan menggunakan Postman untuk memastikan kelima operasi CRUD berfungsi, yaitu GET semua data, GET berdasarkan ID, POST, PUT, dan DELETE.

## 8. Entity Relationship Diagram (ERD)

ERD proyek dapat diakses melalui dbdiagram.io:

https://dbdiagram.io/d/Sistem-Informasi-Kegiatan-Desa-6ad9b905f65bbc60f6fe3168