import 'dart:typed_data';
import '../../core/logging/app_logger.dart';
import '../../domain/repositories/qr_repository.dart';
import '../datasources/qr_service.dart';

class QrRepositoryImpl implements QrRepository {
  final QrService qrService;
  final AppLogger logger;

  QrRepositoryImpl({
    required this.qrService,
    required this.logger,
  });

  @override
  Future<Uint8List> generateQrImage({
    required String text,
    Uint8List? logoBytes,
    double size = 500.0,
  }) async {
    logger.info('QrRepositoryImpl: Requesting QR JPG generation from service', tag: 'Data');
    try {
      final jpgBytes = await qrService.generateQrJpgBytes(
        text: text,
        size: size,
        logoBytes: logoBytes,
      );
      return jpgBytes;
    } catch (e, stackTrace) {
      logger.error(
        'QrRepositoryImpl: Error generating QR JPG',
        tag: 'Data',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
