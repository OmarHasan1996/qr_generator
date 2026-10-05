import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

import 'file_storage_service.dart';

FileStorageService createFileStorageService() => FileStorageServiceImpl();

class FileStorageServiceImpl implements FileStorageService {
  @override
  Future<String?> pickSaveDirectory() async {
    // On Web, file destination directory is controlled directly by the browser download settings
    return null;
  }

  @override
  Future<String> saveImageFile({
    required Uint8List bytes,
    required String fileName,
    String? customDirectory,
  }) async {
    final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: 'image/png'));
    final url = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = fileName;
    web.document.body?.appendChild(anchor);
    anchor.click();
    web.document.body?.removeChild(anchor);
    web.URL.revokeObjectURL(url);
    return 'Downloads/$fileName';
  }
}
