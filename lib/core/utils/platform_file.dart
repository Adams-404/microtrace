import 'dart:typed_data';

import 'platform_file_stub.dart'
    if (dart.library.io) 'platform_file_native.dart';

abstract class PlatformFileOps {
  static bool fileExists(String path) => platformFileExists(path);
  static Uint8List? readFileBytes(String path) => platformReadFileBytes(path);
  static void writeBytes(String path, Uint8List bytes) =>
      platformWriteBytes(path, bytes);
  static void ensureDirectory(String dirPath) =>
      platformEnsureDirectory(dirPath);
}
