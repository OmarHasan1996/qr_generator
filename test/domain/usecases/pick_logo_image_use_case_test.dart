import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_generator/core/logging/app_logger.dart';
import 'package:qr_generator/domain/repositories/image_picker_repository.dart';
import 'package:qr_generator/domain/usecases/pick_logo_image_use_case.dart';

class MockImagePickerRepository extends Mock implements ImagePickerRepository {}
class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockImagePickerRepository mockRepository;
  late MockAppLogger mockLogger;
  late PickLogoImageUseCase useCase;

  setUp(() {
    mockRepository = MockImagePickerRepository();
    mockLogger = MockAppLogger();
    useCase = PickLogoImageUseCase(
      imagePickerRepository: mockRepository,
      logger: mockLogger,
    );
  });

  group('PickLogoImageUseCase', () {
    test('given repository returns image bytes when execute is called then returns bytes', () async {
      // Given
      final expectedBytes = Uint8List.fromList([10, 20, 30]);
      when(() => mockRepository.pickLogoImage()).thenAnswer((_) async => expectedBytes);

      // When
      final result = await useCase.execute();

      // Then
      expect(result, equals(expectedBytes));
      verify(() => mockRepository.pickLogoImage()).called(1);
    });

    test('given repository returns null when user cancels selection then returns null', () async {
      // Given
      when(() => mockRepository.pickLogoImage()).thenAnswer((_) async => null);

      // When
      final result = await useCase.execute();

      // Then
      expect(result, isNull);
    });

    test('given repository throws error when execute is called then rethrows error', () async {
      // Given
      final exception = Exception('Picker exception');
      when(() => mockRepository.pickLogoImage()).thenThrow(exception);

      // When & Then
      expect(() => useCase.execute(), throwsA(equals(exception)));
    });
  });
}
