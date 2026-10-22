-- =========================================
-- SISTEM INFORMASI KEGIATAN DESA
-- Tabel 1: Warga
-- =========================================
CREATE TABLE warga (
    id_warga INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nik VARCHAR(16) UNIQUE NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    jenis_kelamin VARCHAR(20),
    alamat TEXT NOT NULL,
    no_telepon VARCHAR(20),
    tanggal_lahir DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- TABEL 2: KATEGORI KEGIATAN
-- =========================================
CREATE TABLE kategori_kegiatan (
    id_kategori INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL UNIQUE,
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- TABEL 3: LOKASI KEGIATAN
-- =========================================
CREATE TABLE lokasi (
    id_lokasi INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_lokasi VARCHAR(100) NOT NULL,
    alamat_lokasi TEXT NOT NULL,
    keterangan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- TABEL 4: KEGIATAN DESA
-- =========================================
CREATE TABLE kegiatan (
    id_kegiatan INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_kategori INTEGER NOT NULL,
    id_lokasi INTEGER NOT NULL,
    nama_kegiatan VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE,
    status_kegiatan VARCHAR(30) NOT NULL DEFAULT 'direncanakan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_kegiatan_kategori
        FOREIGN KEY (id_kategori)
        REFERENCES kategori_kegiatan(id_kategori),

    CONSTRAINT fk_kegiatan_lokasi
        FOREIGN KEY (id_lokasi)
        REFERENCES lokasi(id_lokasi),

    CONSTRAINT chk_status_kegiatan
        CHECK (
            status_kegiatan IN (
                'direncanakan',
                'berlangsung',
                'selesai',
                'dibatalkan'
            )
        ),

    CONSTRAINT chk_tanggal_kegiatan
        CHECK (
            tanggal_selesai IS NULL
            OR tanggal_selesai >= tanggal_mulai
        )
);

-- =========================================
-- TABEL 5: JADWAL KEGIATAN
-- =========================================
CREATE TABLE jadwal_kegiatan (
    id_jadwal INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_kegiatan INTEGER NOT NULL,
    tanggal DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME NOT NULL,
    keterangan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_jadwal_kegiatan
        FOREIGN KEY (id_kegiatan)
        REFERENCES kegiatan(id_kegiatan)
        ON DELETE CASCADE,

    CONSTRAINT chk_waktu_jadwal
        CHECK (waktu_selesai > waktu_mulai)
);

-- =========================================
-- TABEL 6: PENDAFTARAN PESERTA
-- =========================================
CREATE TABLE pendaftaran (
    id_pendaftaran INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_warga INTEGER NOT NULL,
    id_kegiatan INTEGER NOT NULL,
    tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pendaftaran VARCHAR(20) NOT NULL DEFAULT 'terdaftar',

    CONSTRAINT fk_pendaftaran_warga
        FOREIGN KEY (id_warga)
        REFERENCES warga(id_warga),

    CONSTRAINT fk_pendaftaran_kegiatan
        FOREIGN KEY (id_kegiatan)
        REFERENCES kegiatan(id_kegiatan)
        ON DELETE CASCADE,

    CONSTRAINT uq_pendaftaran_warga_kegiatan
        UNIQUE (id_warga, id_kegiatan),

    CONSTRAINT chk_status_pendaftaran
        CHECK (
            status_pendaftaran IN (
                'terdaftar',
                'hadir',
                'tidak_hadir',
                'dibatalkan'
            )
        )
);

-- =========================================
-- TABEL 7: PANITIA
-- =========================================
CREATE TABLE panitia (
    id_panitia INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_warga INTEGER NOT NULL,
    id_kegiatan INTEGER NOT NULL,
    jabatan VARCHAR(100) NOT NULL,
    tugas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_panitia_warga
        FOREIGN KEY (id_warga)
        REFERENCES warga(id_warga),

    CONSTRAINT fk_panitia_kegiatan
        FOREIGN KEY (id_kegiatan)
        REFERENCES kegiatan(id_kegiatan)
        ON DELETE CASCADE,

    CONSTRAINT uq_panitia_warga_kegiatan
        UNIQUE (id_warga, id_kegiatan)
);

-- =========================================
-- TABEL 8: DOKUMENTASI KEGIATAN
-- =========================================
CREATE TABLE dokumentasi_kegiatan (
    id_dokumentasi INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_kegiatan INTEGER NOT NULL,
    judul_dokumentasi VARCHAR(150) NOT NULL,
    jenis_dokumentasi VARCHAR(30) NOT NULL DEFAULT 'foto',
    url_dokumentasi TEXT NOT NULL,
    keterangan TEXT,
    tanggal_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_dokumentasi_kegiatan
        FOREIGN KEY (id_kegiatan)
        REFERENCES kegiatan(id_kegiatan)
        ON DELETE CASCADE,

    CONSTRAINT chk_jenis_dokumentasi
        CHECK (
            jenis_dokumentasi IN (
                'foto',
                'video',
                'dokumen'
            )
        )
);

-- =========================================
-- TABEL 9: KEHADIRAN
-- =========================================
CREATE TABLE kehadiran (
    id_kehadiran INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pendaftaran INTEGER NOT NULL UNIQUE,
    status_kehadiran VARCHAR(20) NOT NULL DEFAULT 'belum_hadir',
    waktu_hadir TIMESTAMP,
    keterangan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_kehadiran_pendaftaran
        FOREIGN KEY (id_pendaftaran)
        REFERENCES pendaftaran(id_pendaftaran)
        ON DELETE CASCADE,

    CONSTRAINT chk_status_kehadiran
        CHECK (
            status_kehadiran IN (
                'belum_hadir',
                'hadir',
                'izin',
                'alpa'
            )
        )
);