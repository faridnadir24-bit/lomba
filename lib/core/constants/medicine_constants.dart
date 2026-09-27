import 'package:flutter/material.dart';
import 'package:obatku/core/theme/app_colors.dart';

enum SediaanObat {
  tablet,
  kapsul,
  sirup,
  injeksi,
  salep;

  String get displayName {
    switch (this) {
      case SediaanObat.tablet:
        return 'Tablet';
      case SediaanObat.kapsul:
        return 'Kapsul';
      case SediaanObat.sirup:
        return 'Sirup';
      case SediaanObat.injeksi:
        return 'Injeksi';
      case SediaanObat.salep:
        return 'Salep';
    }
  }
}

enum SatuanObat {
  tablet,
  strip,
  botol,
  ampul,
  vial,
  saset;

  String get displayName {
    switch (this) {
      case SatuanObat.tablet:
        return 'Tablet';
      case SatuanObat.strip:
        return 'Strip';
      case SatuanObat.botol:
        return 'Botol';
      case SatuanObat.ampul:
        return 'Ampul';
      case SatuanObat.vial:
        return 'Vial';
      case SatuanObat.saset:
        return 'Saset';
    }
  }
}

enum RakPenyimpanan {
  umum,
  darurat24jam,
  coldChain;

  String get displayName {
    switch (this) {
      case RakPenyimpanan.umum:
        return 'Rak Umum';
      case RakPenyimpanan.darurat24jam:
        return 'Darurat 24 Jam';
      case RakPenyimpanan.coldChain:
        return 'Cold Chain';
    }
  }

  String get description {
    switch (this) {
      case RakPenyimpanan.umum:
        return 'Suhu ruang (15°-25°C)';
      case RakPenyimpanan.darurat24jam:
        return 'Akses cepat 24 jam';
      case RakPenyimpanan.coldChain:
        return 'Suhu dingin (2°-8°C)';
    }
  }
}

enum TipeMutasi {
  masuk,
  keluar,
  koreksi,
  musnah,
  transfer;

  String get displayName {
    switch (this) {
      case TipeMutasi.masuk:
        return 'Penerimaan/Masuk';
      case TipeMutasi.keluar:
        return 'Pengeluaran/Keluar';
      case TipeMutasi.koreksi:
        return 'Koreksi Stok';
      case TipeMutasi.musnah:
        return 'Pemusnahan';
      case TipeMutasi.transfer:
        return 'Transfer/Pindah';
    }
  }
}

enum StatusStok {
  aman,
  waspada,
  kritis;

  String get displayName {
    switch (this) {
      case StatusStok.aman:
        return 'Aman';
      case StatusStok.waspada:
        return 'Waspada';
      case StatusStok.kritis:
        return 'Kritis';
    }
  }

  Color get color {
    switch (this) {
      case StatusStok.aman:
        return AppColors.safeGreen;
      case StatusStok.waspada:
        return AppColors.warningYellow;
      case StatusStok.kritis:
        return AppColors.criticalRed;
    }
  }
}
