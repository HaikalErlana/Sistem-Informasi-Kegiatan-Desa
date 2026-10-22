--
-- PostgreSQL database dump
--

\restrict n6npVeBGoDQ4yCrVElvnFQqj0mqbAEWCZVUKU1x9IanvJ0dzBWEZlodCdEsw7ri

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dokumentasi_kegiatan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dokumentasi_kegiatan (
    id_dokumentasi integer NOT NULL,
    id_kegiatan integer NOT NULL,
    judul_dokumentasi character varying(150) NOT NULL,
    jenis_dokumentasi character varying(30) DEFAULT 'foto'::character varying NOT NULL,
    url_dokumentasi text NOT NULL,
    keterangan text,
    tanggal_upload timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_jenis_dokumentasi CHECK (((jenis_dokumentasi)::text = ANY ((ARRAY['foto'::character varying, 'video'::character varying, 'dokumen'::character varying])::text[])))
);


--
-- Name: dokumentasi_kegiatan_id_dokumentasi_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.dokumentasi_kegiatan ALTER COLUMN id_dokumentasi ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dokumentasi_kegiatan_id_dokumentasi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: jadwal_kegiatan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jadwal_kegiatan (
    id_jadwal integer NOT NULL,
    id_kegiatan integer NOT NULL,
    tanggal date NOT NULL,
    waktu_mulai time without time zone NOT NULL,
    waktu_selesai time without time zone NOT NULL,
    keterangan text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_waktu_jadwal CHECK ((waktu_selesai > waktu_mulai))
);


--
-- Name: jadwal_kegiatan_id_jadwal_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.jadwal_kegiatan ALTER COLUMN id_jadwal ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.jadwal_kegiatan_id_jadwal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kategori_kegiatan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kategori_kegiatan (
    id_kategori integer NOT NULL,
    nama_kategori character varying(100) NOT NULL,
    deskripsi text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: kategori_kegiatan_id_kategori_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.kategori_kegiatan ALTER COLUMN id_kategori ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kategori_kegiatan_id_kategori_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kegiatan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kegiatan (
    id_kegiatan integer NOT NULL,
    id_kategori integer NOT NULL,
    id_lokasi integer NOT NULL,
    nama_kegiatan character varying(150) NOT NULL,
    deskripsi text,
    tanggal_mulai date NOT NULL,
    tanggal_selesai date,
    status_kegiatan character varying(30) DEFAULT 'direncanakan'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_status_kegiatan CHECK (((status_kegiatan)::text = ANY ((ARRAY['direncanakan'::character varying, 'berlangsung'::character varying, 'selesai'::character varying, 'dibatalkan'::character varying])::text[]))),
    CONSTRAINT chk_tanggal_kegiatan CHECK (((tanggal_selesai IS NULL) OR (tanggal_selesai >= tanggal_mulai)))
);


--
-- Name: kegiatan_id_kegiatan_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.kegiatan ALTER COLUMN id_kegiatan ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kegiatan_id_kegiatan_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kehadiran; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kehadiran (
    id_kehadiran integer NOT NULL,
    id_pendaftaran integer NOT NULL,
    status_kehadiran character varying(20) DEFAULT 'belum_hadir'::character varying NOT NULL,
    waktu_hadir timestamp without time zone,
    keterangan text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_status_kehadiran CHECK (((status_kehadiran)::text = ANY ((ARRAY['belum_hadir'::character varying, 'hadir'::character varying, 'izin'::character varying, 'alpa'::character varying])::text[])))
);


--
-- Name: kehadiran_id_kehadiran_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.kehadiran ALTER COLUMN id_kehadiran ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kehadiran_id_kehadiran_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lokasi; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lokasi (
    id_lokasi integer NOT NULL,
    nama_lokasi character varying(100) NOT NULL,
    alamat_lokasi text NOT NULL,
    keterangan text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: lokasi_id_lokasi_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.lokasi ALTER COLUMN id_lokasi ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lokasi_id_lokasi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: panitia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.panitia (
    id_panitia integer NOT NULL,
    id_warga integer NOT NULL,
    id_kegiatan integer NOT NULL,
    jabatan character varying(100) NOT NULL,
    tugas text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: panitia_id_panitia_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.panitia ALTER COLUMN id_panitia ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.panitia_id_panitia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pendaftaran; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pendaftaran (
    id_pendaftaran integer NOT NULL,
    id_warga integer NOT NULL,
    id_kegiatan integer NOT NULL,
    tanggal_daftar timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status_pendaftaran character varying(20) DEFAULT 'terdaftar'::character varying NOT NULL,
    CONSTRAINT chk_status_pendaftaran CHECK (((status_pendaftaran)::text = ANY ((ARRAY['terdaftar'::character varying, 'hadir'::character varying, 'tidak_hadir'::character varying, 'dibatalkan'::character varying])::text[])))
);


--
-- Name: pendaftaran_id_pendaftaran_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.pendaftaran ALTER COLUMN id_pendaftaran ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pendaftaran_id_pendaftaran_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: warga; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.warga (
    id_warga integer NOT NULL,
    nik character varying(16) NOT NULL,
    nama_lengkap character varying(100) NOT NULL,
    jenis_kelamin character varying(20),
    alamat text NOT NULL,
    no_telepon character varying(20),
    tanggal_lahir date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: warga_id_warga_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.warga ALTER COLUMN id_warga ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.warga_id_warga_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: dokumentasi_kegiatan dokumentasi_kegiatan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dokumentasi_kegiatan
    ADD CONSTRAINT dokumentasi_kegiatan_pkey PRIMARY KEY (id_dokumentasi);


--
-- Name: jadwal_kegiatan jadwal_kegiatan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jadwal_kegiatan
    ADD CONSTRAINT jadwal_kegiatan_pkey PRIMARY KEY (id_jadwal);


--
-- Name: kategori_kegiatan kategori_kegiatan_nama_kategori_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kategori_kegiatan
    ADD CONSTRAINT kategori_kegiatan_nama_kategori_key UNIQUE (nama_kategori);


--
-- Name: kategori_kegiatan kategori_kegiatan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kategori_kegiatan
    ADD CONSTRAINT kategori_kegiatan_pkey PRIMARY KEY (id_kategori);


--
-- Name: kegiatan kegiatan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kegiatan
    ADD CONSTRAINT kegiatan_pkey PRIMARY KEY (id_kegiatan);


--
-- Name: kehadiran kehadiran_id_pendaftaran_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kehadiran
    ADD CONSTRAINT kehadiran_id_pendaftaran_key UNIQUE (id_pendaftaran);


--
-- Name: kehadiran kehadiran_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kehadiran
    ADD CONSTRAINT kehadiran_pkey PRIMARY KEY (id_kehadiran);


--
-- Name: lokasi lokasi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lokasi
    ADD CONSTRAINT lokasi_pkey PRIMARY KEY (id_lokasi);


--
-- Name: panitia panitia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panitia
    ADD CONSTRAINT panitia_pkey PRIMARY KEY (id_panitia);


--
-- Name: pendaftaran pendaftaran_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pendaftaran
    ADD CONSTRAINT pendaftaran_pkey PRIMARY KEY (id_pendaftaran);


--
-- Name: panitia uq_panitia_warga_kegiatan; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panitia
    ADD CONSTRAINT uq_panitia_warga_kegiatan UNIQUE (id_warga, id_kegiatan);


--
-- Name: pendaftaran uq_pendaftaran_warga_kegiatan; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pendaftaran
    ADD CONSTRAINT uq_pendaftaran_warga_kegiatan UNIQUE (id_warga, id_kegiatan);


--
-- Name: warga warga_nik_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warga
    ADD CONSTRAINT warga_nik_key UNIQUE (nik);


--
-- Name: warga warga_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warga
    ADD CONSTRAINT warga_pkey PRIMARY KEY (id_warga);


--
-- Name: dokumentasi_kegiatan fk_dokumentasi_kegiatan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dokumentasi_kegiatan
    ADD CONSTRAINT fk_dokumentasi_kegiatan FOREIGN KEY (id_kegiatan) REFERENCES public.kegiatan(id_kegiatan) ON DELETE CASCADE;


--
-- Name: jadwal_kegiatan fk_jadwal_kegiatan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jadwal_kegiatan
    ADD CONSTRAINT fk_jadwal_kegiatan FOREIGN KEY (id_kegiatan) REFERENCES public.kegiatan(id_kegiatan) ON DELETE CASCADE;


--
-- Name: kegiatan fk_kegiatan_kategori; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kegiatan
    ADD CONSTRAINT fk_kegiatan_kategori FOREIGN KEY (id_kategori) REFERENCES public.kategori_kegiatan(id_kategori);


--
-- Name: kegiatan fk_kegiatan_lokasi; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kegiatan
    ADD CONSTRAINT fk_kegiatan_lokasi FOREIGN KEY (id_lokasi) REFERENCES public.lokasi(id_lokasi);


--
-- Name: kehadiran fk_kehadiran_pendaftaran; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kehadiran
    ADD CONSTRAINT fk_kehadiran_pendaftaran FOREIGN KEY (id_pendaftaran) REFERENCES public.pendaftaran(id_pendaftaran) ON DELETE CASCADE;


--
-- Name: panitia fk_panitia_kegiatan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panitia
    ADD CONSTRAINT fk_panitia_kegiatan FOREIGN KEY (id_kegiatan) REFERENCES public.kegiatan(id_kegiatan) ON DELETE CASCADE;


--
-- Name: panitia fk_panitia_warga; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panitia
    ADD CONSTRAINT fk_panitia_warga FOREIGN KEY (id_warga) REFERENCES public.warga(id_warga);


--
-- Name: pendaftaran fk_pendaftaran_kegiatan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pendaftaran
    ADD CONSTRAINT fk_pendaftaran_kegiatan FOREIGN KEY (id_kegiatan) REFERENCES public.kegiatan(id_kegiatan) ON DELETE CASCADE;


--
-- Name: pendaftaran fk_pendaftaran_warga; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pendaftaran
    ADD CONSTRAINT fk_pendaftaran_warga FOREIGN KEY (id_warga) REFERENCES public.warga(id_warga);


--
-- PostgreSQL database dump complete
--

\unrestrict n6npVeBGoDQ4yCrVElvnFQqj0mqbAEWCZVUKU1x9IanvJ0dzBWEZlodCdEsw7ri

