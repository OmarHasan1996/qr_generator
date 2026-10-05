import 'dart:typed_data';

abstract class QrRepository {
  /// Generates a PNG byte array of a QR code containing [text] and optional embedded [logoBytes].
  Future<Uint8List> generateQrImage({
    required String text,
    Uint8List? logoBytes,
    double size = 300.0,
  });
}
