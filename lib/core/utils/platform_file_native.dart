import 'dart:io';
import 'dart:typed_data';

bool platformFileExists(String path) {
  try {
    return File(path).existsSync();
  } catch (_) {
    return false;
  }
}

Uint8List? platformReadFileBytes(String path) {
  try {
    final file = File(path);
    if (file.existsSync()) {
      return file.readAsBytesSync();
    }
  } catch (_) {}
  return null;
}

void platformWriteBytes(String path, Uint8List bytes) {
  try {
    final file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(bytes, flush: true);
  } catch (_) {}
}

void platformEnsureDirectory(String dirPath) {
  try {
    Directory(dirPath).createSync(recursive: true);
  } catch (_) {}
}
