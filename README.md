# OBATKU 💊

**Sistem Manajemen Stok Obat Offline-First untuk Puskesmas & Daerah 3T Indonesia**

![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-Proprietary-red)

## Tentang

OBATKU adalah aplikasi mobile inventaris dan logistik farmasi berprinsip *offline-first* yang memberdayakan tenaga kesehatan puskesmas lapangan untuk:

- 📦 **Mencatat stok obat** masuk/keluar dengan cepat
- ⏰ **Memantau masa kedaluwarsa** dengan sistem peringatan dini 3 tier (Kritis/Waspada/Perhatian)
- 🤖 **Memprediksi kebutuhan obat** menggunakan Edge AI lokal
- 🔄 **Menyinkronkan data** melalui multi-kanal (WiFi, SMS, Bluetooth, SD Card)
- 📊 **Mengotomasi RKO** (Rencana Kebutuhan Obat)

## Target Pengguna

| Persona | Peran |
|:---|:---|
| Bidan/Perawat Lapangan | Pencatatan obat harian di Pustu/Poskesdes |
| Pengelola Farmasi Puskesmas | Rekap data dari poskesdes, laporan RKO |
| Petugas Logistik Dinkes | Verifikasi distribusi obat se-kabupaten |

## Teknologi

- **Framework:** Flutter 3.24+ (Dart 3.5+)
- **Database:** SQLite (sqflite) — offline-first, ACID compliant
- **State Management:** Riverpod 2.x
- **Navigation:** GoRouter 14.x
- **Charts:** fl_chart 0.68+
- **Lokalisasi:** Bahasa Indonesia (id_ID) menggunakan terminologi BPOM/Kemenkes

## Struktur Project

```
lib/
├── core/           # Infrastruktur bersama (database, tema, router, widget)
├── features/       # Modul fitur (6 screen)
│   ├── dashboard/         # Beranda & metrik utama
│   ├── inventory/         # Katalog & inventaris obat
│   ├── expiry_warning/    # Peringatan kedaluwarsa (EWS)
│   ├── prediction/        # Prediksi kebutuhan AI
│   ├── sync/              # Sinkronisasi data multi-kanal
│   └── add_medicine/      # Tambah/mutasi obat
└── l10n/           # Lokalisasi
```

## Setup & Build

```bash
# Install dependencies
flutter pub get

# Run di emulator/device
flutter run

# Build APK release
flutter build apk --release
```

## Prinsip Desain

1. **True Offline-First** — SQLite lokal sebagai single source of truth
2. **High-Contrast UI** — Palet medis dengan target sentuh 56dp+ untuk penggunaan lapangan
3. **Bahasa Indonesia** — Terminologi standar BPOM/Kemenkes RI
4. **Low-End Device Ready** — Optimal di Android 9+ dengan RAM 2GB

## Roadmap

- [x] **Fase 1 (MVP):** SQLite, Dashboard, Inventaris, Peringatan Kedaluwarsa, Form Obat, Ekspor CSV
- [ ] **Fase 2:** SMS Gateway 2G, REST API Sync, Notifikasi Push
- [ ] **Fase 3:** Edge AI Prediksi RKO, LoRa Mesh, Bluetooth P2P
