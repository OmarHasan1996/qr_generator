import 'dart:typed_data';
import '../../core/logging/app_logger.dart';
import '../repositories/qr_repository.dart';

class GenerateQrCodeUseCase {
  final QrRepository qrRepository;
  final AppLogger logger;

  GenerateQrCodeUseCase({
    required this.qrRepository,
    required this.logger,
  });

  Future<Uint8List> execute({
    required String text,
    Uint8List? logoBytes,
    double size = 300.0,
  }) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      logger.warn('GenerateQrCodeUseCase: Text content is empty', tag: 'UseCase');
      throw ArgumentError('QR code text content cannot be empty.');
    }

    logger.info(
      'GenerateQrCodeUseCase: Generating QR code for input length=${trimmedText.length}',
      tag: 'UseCase',
      metadata: {'hasLogo': logoBytes != null && logoBytes.isNotEmpty},
    );

    try {
      return await qrRepository.generateQrImage(
        text: trimmedText,
        logoBytes: logoBytes,
        size: size,
      );
    } catch (e, stackTrace) {
      logger.error(
        'GenerateQrCodeUseCase: Failed to generate QR code',
        tag: 'UseCase',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
