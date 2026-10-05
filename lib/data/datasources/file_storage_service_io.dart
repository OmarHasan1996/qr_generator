import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'file_storage_service.dart';

FileStorageService createFileStorageService() => FileStorageServiceImpl();

class FileStorageServiceImpl implements FileStorageService {
  @override
  Future<String?> pickSaveDirectory() async {
    try {
      final String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select Directory to Save QR Code',
      );
      return selectedDirectory;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String> saveImageFile({
    required Uint8List bytes,
    required String fileName,
    String? customDirectory,
  }) async {
    Directory targetDir;
    if (customDirectory != null && customDirectory.isNotEmpty) {
      targetDir = Directory(customDirectory);
    } else if (Platform.isAndroid) {
      final extDir = await getExternalStorageDirectory();
      targetDir = extDir ?? await getApplicationDocumentsDirectory();
    } else {
      targetDir = await getApplicationDocumentsDirectory();
    }

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final String filePath = '${targetDir.path}/$fileName';
    final File file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    return filePath;
  }
}
