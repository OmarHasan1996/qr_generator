import 'dart:typed_data';
import '../../core/logging/app_logger.dart';
import '../repositories/file_storage_repository.dart';

class SaveQrCodeUseCase {
  final FileStorageRepository fileStorageRepository;
  final AppLogger logger;

  SaveQrCodeUseCase({
    required this.fileStorageRepository,
    required this.logger,
  });

  Future<String?> selectSaveDirectory() async {
    return await fileStorageRepository.selectDirectory();
  }

  Future<String> execute({
    required Uint8List imageBytes,
    String? customFileName,
    String? customDirectory,
  }) async {
    if (imageBytes.isEmpty) {
      logger.warn('SaveQrCodeUseCase: Empty image bytes provided', tag: 'UseCase');
      throw ArgumentError('Cannot save empty image data.');
    }

    final fileName = customFileName ?? 'qr_code_${DateTime.now().millisecondsSinceEpoch}.png';

    logger.info(
      'SaveQrCodeUseCase: Saving QR image file=$fileName size=${imageBytes.length} bytes, dir=$customDirectory',
      tag: 'UseCase',
    );

    try {
      final savedPath = await fileStorageRepository.saveQrCodeImage(
        imageBytes: imageBytes,
        fileName: fileName,
        customDirectory: customDirectory,
      );
      logger.info('SaveQrCodeUseCase: QR code image saved successfully at $savedPath', tag: 'UseCase');
      return savedPath;
    } catch (e, stackTrace) {
      logger.error(
        'SaveQrCodeUseCase: Failed to save QR image',
        tag: 'UseCase',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
