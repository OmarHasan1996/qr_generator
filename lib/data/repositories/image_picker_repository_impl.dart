import 'dart:typed_data';
import '../../core/logging/app_logger.dart';
import '../../domain/repositories/image_picker_repository.dart';
import '../datasources/image_picker_service.dart';

class ImagePickerRepositoryImpl implements ImagePickerRepository {
  final ImagePickerService imagePickerService;
  final AppLogger logger;

  ImagePickerRepositoryImpl({
    required this.imagePickerService,
    required this.logger,
  });

  @override
  Future<Uint8List?> pickLogoImage() async {
    logger.info('ImagePickerRepositoryImpl: Invoking image picker service', tag: 'Data');
    try {
      return await imagePickerService.pickImageFromGallery();
    } catch (e, stackTrace) {
      logger.error(
        'ImagePickerRepositoryImpl: Error picking image',
        tag: 'Data',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
