import 'package:intl/intl.dart';
import 'package:obatku/core/constants/app_constants.dart';
import 'package:obatku/core/constants/medicine_constants.dart';

abstract final class ObatkuDateUtils {
  /// Returns days from today to expiry date. Negative if expired.
  static int daysUntilExpiry(DateTime expiryDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }

  /// Maps days left to StatusStok based on thresholds.
  static StatusStok getExpiryStatus(int daysLeft) {
    if (daysLeft <= AppConstants.expiryCriticalDays) {
      return StatusStok.kritis;
    } else if (daysLeft <= AppConstants.expiryWarningDays) {
      return StatusStok.waspada;
    } else {
      return StatusStok.aman;
    }
  }

  /// Indonesian format "15 Oktober 2026"
  static String formatTanggal(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  /// Returns text like "Sudah kedaluwarsa!" or "2 hari lagi!"
  static String formatCountdown(int days) {
    if (days < 0) {
      return 'Sudah kedaluwarsa!';
    } else if (days == 0) {
      return 'Kedaluwarsa hari ini!';
    } else {
      return '$days hari lagi';
    }
  }

  /// Format "Oktober 2026"
  static String formatBulanTahun(DateTime date) {
    return DateFormat('MMMM yyyy', 'id_ID').format(date);
  }

  /// Returns the last day of the given month/year
  static DateTime lastDayOfMonth(int year, int month) {
    // Move to the first day of the next month, then subtract 1 day
    return DateTime(year, month + 1, 0);
  }
}
