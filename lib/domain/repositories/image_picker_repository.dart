import 'dart:typed_data';

abstract class ImagePickerRepository {
  /// Picks an image from device gallery or storage and returns raw bytes.
  Future<Uint8List?> pickLogoImage();
}
