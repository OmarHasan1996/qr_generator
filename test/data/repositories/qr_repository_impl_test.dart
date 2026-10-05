import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_generator/core/logging/app_logger.dart';
import 'package:qr_generator/data/datasources/qr_service.dart';
import 'package:qr_generator/data/repositories/qr_repository_impl.dart';

class MockQrService extends Mock implements QrService {}
class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockQrService mockQrService;
  late MockAppLogger mockLogger;
  late QrRepositoryImpl repository;

  setUp(() {
    mockQrService = MockQrService();
    mockLogger = MockAppLogger();
    repository = QrRepositoryImpl(
      qrService: mockQrService,
      logger: mockLogger,
    );
  });

  group('QrRepositoryImpl', () {
    test('given valid text when generateQrImage is called then delegates to QrService', () async {
      // Given
      const text = 'test string';
      final expectedBytes = Uint8List.fromList([100, 200]);
      when(() => mockQrService.generateQrPngBytes(
            text: text,
            size: 300.0,
            logoBytes: null,
          )).thenAnswer((_) async => expectedBytes);

      // When
      final result = await repository.generateQrImage(text: text);

      // Then
      expect(result, equals(expectedBytes));
      verify(() => mockQrService.generateQrPngBytes(
            text: text,
            size: 300.0,
            logoBytes: null,
          )).called(1);
    });

    test('given QrService failure when generateQrImage is called then logs and rethrows', () async {
      // Given
      const text = 'test string';
      final exception = Exception('Service error');
      when(() => mockQrService.generateQrPngBytes(
            text: text,
            size: 300.0,
            logoBytes: null,
          )).thenThrow(exception);

      // When & Then
      expect(() => repository.generateQrImage(text: text), throwsA(equals(exception)));
    });
  });
}
