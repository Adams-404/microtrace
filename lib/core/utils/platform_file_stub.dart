import 'dart:typed_data';

bool platformFileExists(String path) => false;
Uint8List? platformReadFileBytes(String path) => null;
void platformWriteBytes(String path, Uint8List bytes) {}
void platformEnsureDirectory(String dirPath) {}
