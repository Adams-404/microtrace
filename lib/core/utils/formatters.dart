import 'package:intl/intl.dart';

class Formatters {
  static final _dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  static final _shortDateFormat = DateFormat('MMM d, yyyy');
  static final _timeFormat = DateFormat('HH:mm:ss');

  static String formatDateTime(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }

  static String formatShortDate(DateTime dateTime) {
    return _shortDateFormat.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
