import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_generator/core/logging/app_logger.dart';
import 'package:qr_generator/domain/repositories/qr_repository.dart';
import 'package:qr_generator/domain/usecases/generate_qr_code_use_case.dart';

class MockQrRepository extends Mock implements QrRepository {}
class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockQrRepository mockRepository;
  late MockAppLogger mockLogger;
  late GenerateQrCodeUseCase useCase;

  setUp(() {
    mockRepository = MockQrRepository();
    mockLogger = MockAppLogger();
    useCase = GenerateQrCodeUseCase(
      qrRepository: mockRepository,
      logger: mockLogger,
    );
  });

  group('GenerateQrCodeUseCase', () {
    test('given valid text input when execute is called then returns generated png bytes', () async {
      // Given
      const input = 'https://example.com';
      final expectedBytes = Uint8List.fromList([1, 2, 3, 4]);
      when(() => mockRepository.generateQrImage(
            text: input,
            logoBytes: null,
            size: 512.0,
          )).thenAnswer((_) async => expectedBytes);

      // When
      final result = await useCase.execute(text: input);

      // Then
      expect(result, equals(expectedBytes));
      verify(() => mockRepository.generateQrImage(
            text: input,
            logoBytes: null,
            size: 512.0,
          )).called(1);
    });

    test('given empty or whitespace text when execute is called then throws ArgumentError', () async {
      // Given
      const input = '   ';

      // When & Then
      expect(() => useCase.execute(text: input), throwsArgumentError);
      verifyZeroInteractions(mockRepository);
    });

    test('given repository throws error when execute is called then rethrows error', () async {
      // Given
      const input = 'valid input';
      final exception = Exception('Generation failed');
      when(() => mockRepository.generateQrImage(
            text: input,
            logoBytes: null,
            size: 512.0,
          )).thenThrow(exception);

      // When & Then
      expect(() => useCase.execute(text: input), throwsA(equals(exception)));
    });
  });
}
