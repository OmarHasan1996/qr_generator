import 'dart:typed_data';
import '../../core/logging/app_logger.dart';
import '../../domain/repositories/file_storage_repository.dart';
import '../datasources/file_storage_service.dart';

class FileStorageRepositoryImpl implements FileStorageRepository {
  final FileStorageService fileStorageService;
  final AppLogger logger;

  FileStorageRepositoryImpl({
    required this.fileStorageService,
    required this.logger,
  });

  @override
  Future<String?> selectDirectory() async {
    logger.info('FileStorageRepositoryImpl: Opening directory selection dialog', tag: 'Data');
    try {
      final path = await fileStorageService.pickSaveDirectory();
      if (path != null) {
        logger.info('FileStorageRepositoryImpl: Selected directory $path', tag: 'Data');
      }
      return path;
    } catch (e, stackTrace) {
      logger.error('FileStorageRepositoryImpl: Directory selection failed', tag: 'Data', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<String> saveQrCodeImage({
    required Uint8List imageBytes,
    required String fileName,
    String? customDirectory,
  }) async {
    logger.info('FileStorageRepositoryImpl: Saving $fileName (customDir: $customDirectory)', tag: 'Data');
    try {
      final savedPath = await fileStorageService.saveImageFile(
        bytes: imageBytes,
        fileName: fileName,
        customDirectory: customDirectory,
      );
      return savedPath;
    } catch (e, stackTrace) {
      logger.error(
        'FileStorageRepositoryImpl: Failed saving file',
        tag: 'Data',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
