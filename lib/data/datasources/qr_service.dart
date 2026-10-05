import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

abstract class QrService {
  Future<ui.Image> generateQrUiImage({
    required String text,
    required double size,
    ui.Image? embeddedLogo,
  });

  Future<Uint8List> generateQrPngBytes({
    required String text,
    required double size,
    Uint8List? logoBytes,
  });
}

class QrServiceImpl implements QrService {
  @override
  Future<ui.Image> generateQrUiImage({
    required String text,
    required double size,
    ui.Image? embeddedLogo,
  }) async {
    final qrValidationResult = QrValidator.validate(
      data: text,
      version: QrVersions.auto,
      errorCorrectionLevel: embeddedLogo != null
          ? QrErrorCorrectLevel.H
          : QrErrorCorrectLevel.M,
    );

    if (qrValidationResult.status == QrValidationStatus.error) {
      throw Exception('QR validation failed: ${qrValidationResult.error}');
    }

    final qrCode = qrValidationResult.qrCode!;
    final painter = QrPainter.withQr(
      qr: qrCode,
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Color(0xFF000000),
      ),
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Color(0xFF000000),
      ),
      gapless: true,
      embeddedImageStyle: embeddedLogo != null
          ? QrEmbeddedImageStyle(
              size: Size(size * 0.22, size * 0.22),
            )
          : null,
      embeddedImage: embeddedLogo,
    );

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size, size));
    painter.paint(canvas, Size(size, size));
    final picture = recorder.endRecording();

    return await picture.toImage(size.toInt(), size.toInt());
  }

  @override
  Future<Uint8List> generateQrPngBytes({
    required String text,
    required double size,
    Uint8List? logoBytes,
  }) async {
    ui.Image? logoImage;
    if (logoBytes != null && logoBytes.isNotEmpty) {
      final codec = await ui.instantiateImageCodec(logoBytes);
      final frameInfo = await codec.getNextFrame();
      logoImage = frameInfo.image;
    }

    final uiImage = await generateQrUiImage(
      text: text,
      size: size,
      embeddedLogo: logoImage,
    );

    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to convert QR code canvas image to PNG bytes.');
    }

    return byteData.buffer.asUint8List();
  }
}
