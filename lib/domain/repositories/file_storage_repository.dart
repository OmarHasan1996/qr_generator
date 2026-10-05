import 'dart:typed_data';

abstract class FileStorageRepository {
  /// Allows the user to select a custom destination directory (where supported).
  Future<String?> selectDirectory();

  /// Saves PNG image bytes to storage and returns the saved file path.
  Future<String> saveQrCodeImage({
    required Uint8List imageBytes,
    required String fileName,
    String? customDirectory,
  });
}
