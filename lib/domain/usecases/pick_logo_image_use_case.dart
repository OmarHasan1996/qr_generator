import 'dart:typed_data';
import '../../core/logging/app_logger.dart';
import '../repositories/image_picker_repository.dart';

class PickLogoImageUseCase {
  final ImagePickerRepository imagePickerRepository;
  final AppLogger logger;

  PickLogoImageUseCase({
    required this.imagePickerRepository,
    required this.logger,
  });

  Future<Uint8List?> execute() async {
    logger.info('PickLogoImageUseCase: Requesting image pick', tag: 'UseCase');
    try {
      final bytes = await imagePickerRepository.pickLogoImage();
      if (bytes != null) {
        logger.info(
          'PickLogoImageUseCase: Image picked successfully size=${bytes.length} bytes',
          tag: 'UseCase',
        );
      } else {
        logger.info('PickLogoImageUseCase: User cancelled logo selection', tag: 'UseCase');
      }
      return bytes;
    } catch (e, stackTrace) {
      logger.error(
        'PickLogoImageUseCase: Failed to pick image',
        tag: 'UseCase',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
