abstract final class AppConstants {
  static const String appName = 'OBATKU';
  static const String appVersion = '1.0.0-mvp';
  
  static const String databaseName = 'obatku.db';
  static const int databaseVersion = 1;
  
  // Expiry thresholds in days
  static const int expiryCriticalDays = 7;
  static const int expiryWarningDays = 30;
  static const int expiryAttentionDays = 90;
  
  static const int defaultMinStock = 10;
  
  static const double maxTextScale = 1.35;
  static const double touchTargetSize = 56.0;
}
