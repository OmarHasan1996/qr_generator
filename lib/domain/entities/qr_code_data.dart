import 'dart:typed_data';

class QrCodeData {
  final String text;
  final Uint8List? logoBytes;
  final Uint8List? qrImageBytes;

  const QrCodeData({
    required this.text,
    this.logoBytes,
    this.qrImageBytes,
  });

  bool get hasLogo => logoBytes != null && logoBytes!.isNotEmpty;
  bool get hasRenderedImage => qrImageBytes != null && qrImageBytes!.isNotEmpty;

  QrCodeData copyWith({
    String? text,
    Uint8List? logoBytes,
    Uint8List? qrImageBytes,
    bool clearLogo = false,
  }) {
    return QrCodeData(
      text: text ?? this.text,
      logoBytes: clearLogo ? null : (logoBytes ?? this.logoBytes),
      qrImageBytes: qrImageBytes ?? this.qrImageBytes,
    );
  }
}
