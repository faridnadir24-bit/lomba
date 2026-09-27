class Tables {
  static const String createMedicinesTable = '''
    CREATE TABLE IF NOT EXISTS medicines (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      dosage TEXT NOT NULL,
      form TEXT NOT NULL,
      batch_number TEXT NOT NULL,
      quantity INTEGER NOT NULL DEFAULT 0,
      unit TEXT NOT NULL DEFAULT 'tablet',
      expiry_date TEXT NOT NULL,
      min_stock INTEGER NOT NULL DEFAULT 10,
      storage_rack TEXT NOT NULL DEFAULT 'umum',
      notes TEXT,
      synced INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      deleted_at TEXT
    )
  ''';

  static const String createMutationsTable = '''
    CREATE TABLE IF NOT EXISTS mutations (
      id TEXT PRIMARY KEY,
      medicine_id TEXT NOT NULL,
      type TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      reference TEXT,
      performed_by TEXT,
      notes TEXT,
      synced INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE CASCADE
    )
  ''';

  static const String createSyncQueueTable = '''
    CREATE TABLE IF NOT EXISTS sync_queue (
      id TEXT PRIMARY KEY,
      table_name TEXT NOT NULL,
      record_id TEXT NOT NULL,
      operation TEXT NOT NULL,
      payload TEXT NOT NULL,
      priority INTEGER DEFAULT 0,
      attempts INTEGER DEFAULT 0,
      last_attempt TEXT,
      created_at TEXT NOT NULL
    )
  ''';

  static const String createFacilityTable = '''
    CREATE TABLE IF NOT EXISTS facility (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      region_3t INTEGER DEFAULT 1,
      district TEXT,
      province TEXT,
      operator_name TEXT,
      operator_pin TEXT
    )
  ''';

  static const List<String> createIndexes = [
    'CREATE INDEX IF NOT EXISTS idx_medicines_expiry_date ON medicines(expiry_date);',
    'CREATE INDEX IF NOT EXISTS idx_medicines_synced ON medicines(synced);',
    'CREATE INDEX IF NOT EXISTS idx_medicines_quantity ON medicines(quantity);',
    'CREATE INDEX IF NOT EXISTS idx_mutations_medicine_id ON mutations(medicine_id);',
    'CREATE INDEX IF NOT EXISTS idx_mutations_created_at ON mutations(created_at);',
    'CREATE INDEX IF NOT EXISTS idx_sync_queue_priority_created ON sync_queue(priority DESC, created_at ASC);',
  ];
}
