import 'dart:typed_data';

import 'file_storage_service_stub.dart'
    if (dart.library.io) 'file_storage_service_io.dart'
    if (dart.library.js_interop) 'file_storage_service_web.dart';

abstract class FileStorageService {
  Future<String> saveImageFile({
    required Uint8List bytes,
    required String fileName,
    String? customDirectory,
  });

  Future<String?> pickSaveDirectory();

  factory FileStorageService() => createFileStorageService();
}
