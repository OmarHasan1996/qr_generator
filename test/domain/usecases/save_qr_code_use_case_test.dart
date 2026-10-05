import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_generator/core/logging/app_logger.dart';
import 'package:qr_generator/domain/repositories/file_storage_repository.dart';
import 'package:qr_generator/domain/usecases/save_qr_code_use_case.dart';

class MockFileStorageRepository extends Mock implements FileStorageRepository {}
class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockFileStorageRepository mockRepository;
  late MockAppLogger mockLogger;
  late SaveQrCodeUseCase useCase;

  setUp(() {
    mockRepository = MockFileStorageRepository();
    mockLogger = MockAppLogger();
    useCase = SaveQrCodeUseCase(
      fileStorageRepository: mockRepository,
      logger: mockLogger,
    );
  });

  group('SaveQrCodeUseCase', () {
    test('given valid image bytes when execute is called then returns saved path', () async {
      // Given
      final imageBytes = Uint8List.fromList([1, 2, 3]);
      const expectedPath = '/storage/qr_code_123.png';
      when(() => mockRepository.saveQrCodeImage(
            imageBytes: imageBytes,
            fileName: any(named: 'fileName'),
          )).thenAnswer((_) async => expectedPath);

      // When
      final result = await useCase.execute(imageBytes: imageBytes);

      // Then
      expect(result, equals(expectedPath));
    });

    test('given empty image bytes when execute is called then throws ArgumentError', () async {
      // Given
      final emptyBytes = Uint8List(0);

      // When & Then
      expect(() => useCase.execute(imageBytes: emptyBytes), throwsArgumentError);
      verifyZeroInteractions(mockRepository);
    });

    test('given repository failure when execute is called then rethrows exception', () async {
      // Given
      final imageBytes = Uint8List.fromList([1, 2, 3]);
      final exception = Exception('Disk full');
      when(() => mockRepository.saveQrCodeImage(
            imageBytes: imageBytes,
            fileName: any(named: 'fileName'),
          )).thenThrow(exception);

      // When & Then
      expect(() => useCase.execute(imageBytes: imageBytes), throwsA(equals(exception)));
    });
  });
}
