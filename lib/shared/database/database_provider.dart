import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = AppDatabase();
  ref.onDispose(() {
    db.close();
  });
  return db;
});
