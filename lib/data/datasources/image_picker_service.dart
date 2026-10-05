import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

abstract class ImagePickerService {
  Future<Uint8List?> pickImageFromGallery();
}

class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker;

  ImagePickerServiceImpl({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  @override
  Future<Uint8List?> pickImageFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (file == null) return null;
    return await file.readAsBytes();
  }
}
