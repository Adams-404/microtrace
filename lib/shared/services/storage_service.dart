import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageMetrics {
  final int databaseBytes;
  final int rawImagesBytes;
  final int modelsBytes;
  final int reportsBytes;

  const StorageMetrics({
    required this.databaseBytes,
    required this.rawImagesBytes,
    required this.modelsBytes,
    required this.reportsBytes,
  });

  int get totalBytes => databaseBytes + rawImagesBytes + modelsBytes + reportsBytes;

  StorageMetrics copyWith({
    int? databaseBytes,
    int? rawImagesBytes,
    int? modelsBytes,
    int? reportsBytes,
  }) {
    return StorageMetrics(
      databaseBytes: databaseBytes ?? this.databaseBytes,
      rawImagesBytes: rawImagesBytes ?? this.rawImagesBytes,
      modelsBytes: modelsBytes ?? this.modelsBytes,
      reportsBytes: reportsBytes ?? this.reportsBytes,
    );
  }
}

final storageServiceProvider = NotifierProvider<StorageServiceNotifier, StorageMetrics>(
  StorageServiceNotifier.new,
);

class StorageServiceNotifier extends Notifier<StorageMetrics> {
  @override
  StorageMetrics build() {
    return const StorageMetrics(
      databaseBytes: 425984, // ~416 KB SQLite
      rawImagesBytes: 18454912, // ~17.6 MB
      modelsBytes: 18874367, // ~18.0 MB LiteRT models
      reportsBytes: 2457600, // ~2.3 MB cached PDF/JSON
    );
  }

  void clearReportsCache() {
    state = state.copyWith(reportsBytes: 0);
  }

  void purgeAllCache() {
    state = state.copyWith(
      rawImagesBytes: 1240000,
      reportsBytes: 0,
    );
  }
}
