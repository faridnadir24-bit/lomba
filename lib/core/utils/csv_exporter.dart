import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:obatku/core/utils/obatku_date_utils.dart';
import 'package:obatku/features/inventory/data/models/medicine.dart';

abstract final class CsvExporter {
  /// Exports inventory to a CSV file.
  /// Returns the absolute path of the generated file.
  static Future<String> exportInventoryToCsv(List<Medicine> medicines, String faskesName) async {
    final List<List<dynamic>> csvData = [];
    
    // Header
    csvData.add([
      'No',
      'Nama Obat',
      'Dosis',
      'Sediaan',
      'No. Bets',
      'Jumlah',
      'Satuan',
      'Tgl Kedaluwarsa',
      'Rak Penyimpanan',
      'Status'
    ]);

    for (int i = 0; i < medicines.length; i++) {
      final m = medicines[i];
      final daysLeft = ObatkuDateUtils.daysUntilExpiry(m.expiryDate);
      final status = ObatkuDateUtils.getExpiryStatus(daysLeft).displayName;
      
      csvData.add([
        i + 1,
        m.name,
        m.dose,
        m.sediaan.displayName,
        m.batchNumber,
        m.stock,
        m.satuan.displayName,
        ObatkuDateUtils.formatTanggal(m.expiryDate),
        m.rak.displayName,
        status,
      ]);
    }

    final String csvStr = const ListToCsvConverter().convert(csvData);
    
    final Directory dir = await getApplicationDocumentsDirectory();
    // Use external storage if available on Android
    Directory? exportDir = dir;
    if (Platform.isAndroid) {
      exportDir = (await getExternalStorageDirectory()) ?? dir;
    }
    
    final dateStr = DateFormat('yyyyMMdd').format(DateTime.now());
    final faskesSafeName = faskesName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final String fileName = 'OBATKU_StokObat_${faskesSafeName}_$dateStr.csv';
    final String filePath = '${exportDir.path}/$fileName';
    
    final File file = File(filePath);
    await file.writeAsString(csvStr);
    
    return filePath;
  }
}
