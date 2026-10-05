import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_generator/core/logging/app_logger.dart';
import 'package:qr_generator/domain/usecases/generate_qr_code_use_case.dart';
import 'package:qr_generator/domain/usecases/pick_logo_image_use_case.dart';
import 'package:qr_generator/domain/usecases/save_qr_code_use_case.dart';
import 'package:qr_generator/presentation/state/qr_generator_event.dart';
import 'package:qr_generator/presentation/state/qr_generator_state.dart';
import 'package:qr_generator/presentation/viewmodels/qr_generator_view_model.dart';

class MockGenerateQrCodeUseCase extends Mock implements GenerateQrCodeUseCase {}
class MockPickLogoImageUseCase extends Mock implements PickLogoImageUseCase {}
class MockSaveQrCodeUseCase extends Mock implements SaveQrCodeUseCase {}
class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockGenerateQrCodeUseCase mockGenerateUseCase;
  late MockPickLogoImageUseCase mockPickLogoUseCase;
  late MockSaveQrCodeUseCase mockSaveUseCase;
  late MockAppLogger mockLogger;
  late QrGeneratorViewModel viewModel;

  setUp(() {
    mockGenerateUseCase = MockGenerateQrCodeUseCase();
    mockPickLogoUseCase = MockPickLogoImageUseCase();
    mockSaveUseCase = MockSaveQrCodeUseCase();
    mockLogger = MockAppLogger();

    viewModel = QrGeneratorViewModel(
      generateQrCodeUseCase: mockGenerateUseCase,
      pickLogoImageUseCase: mockPickLogoUseCase,
      saveQrCodeUseCase: mockSaveUseCase,
      logger: mockLogger,
    );
  });

  group('QrGeneratorViewModel', () {
    test('given initial state when created then has default values', () {
      // Given & When
      final state = viewModel.state;

      // Then
      expect(state.inputText, isEmpty);
      expect(state.logoBytes, isNull);
      expect(state.qrImageBytes, isNull);
      expect(state.status, equals(QrGeneratorStatus.initial));
    });

    test('given TextChangedEvent when dispatched then updates inputText in state', () {
      // Given
      const text = 'Hello QR';

      // When
      viewModel.onEvent(const TextChangedEvent(text));

      // Then
      expect(viewModel.state.inputText, equals(text));
    });

    test('given PickLogoRequestedEvent and user picks image when dispatched then updates logoBytes', () async {
      // Given
      final logoBytes = Uint8List.fromList([1, 2, 3]);
      when(() => mockPickLogoUseCase.execute()).thenAnswer((_) async => logoBytes);

      // When
      viewModel.onEvent(const PickLogoRequestedEvent());
      await Future.delayed(Duration.zero);

      // Then
      expect(viewModel.state.logoBytes, equals(logoBytes));
    });

    test('given RemoveLogoRequestedEvent when dispatched then clears logoBytes', () async {
      // Given
      final logoBytes = Uint8List.fromList([1, 2, 3]);
      when(() => mockPickLogoUseCase.execute()).thenAnswer((_) async => logoBytes);
      viewModel.onEvent(const PickLogoRequestedEvent());
      await Future.delayed(Duration.zero);

      // When
      viewModel.onEvent(const RemoveLogoRequestedEvent());

      // Then
      expect(viewModel.state.logoBytes, isNull);
    });

    test('given valid input and GenerateQrRequestedEvent when dispatched then generates QR successfully', () async {
      // Given
      const text = 'https://example.com';
      final qrBytes = Uint8List.fromList([9, 9, 9]);
      viewModel.onEvent(const TextChangedEvent(text));

      when(() => mockGenerateUseCase.execute(text: text, logoBytes: null))
          .thenAnswer((_) async => qrBytes);

      // When
      viewModel.onEvent(const GenerateQrRequestedEvent());
      await Future.delayed(Duration.zero);

      // Then
      expect(viewModel.state.qrImageBytes, equals(qrBytes));
      expect(viewModel.state.status, equals(QrGeneratorStatus.success));
      expect(viewModel.state.successMessage, contains('generated successfully'));
    });

    test('given empty input and GenerateQrRequestedEvent when dispatched then sets error state', () async {
      // Given
      viewModel.onEvent(const TextChangedEvent('  '));

      // When
      viewModel.onEvent(const GenerateQrRequestedEvent());

      // Then
      expect(viewModel.state.status, equals(QrGeneratorStatus.error));
      expect(viewModel.state.errorMessage, contains('Please enter text'));
    });

    test('given generated image and SaveQrRequestedEvent when dispatched then saves successfully', () async {
      // Given
      const text = 'https://example.com';
      final qrBytes = Uint8List.fromList([9, 9, 9]);
      viewModel.onEvent(const TextChangedEvent(text));

      when(() => mockGenerateUseCase.execute(text: text, logoBytes: null))
          .thenAnswer((_) async => qrBytes);
      viewModel.onEvent(const GenerateQrRequestedEvent());
      await Future.delayed(Duration.zero);

      const savedPath = '/storage/qr.png';
      when(() => mockSaveUseCase.execute(imageBytes: qrBytes))
          .thenAnswer((_) async => savedPath);

      // When
      viewModel.onEvent(const SaveQrRequestedEvent());
      await Future.delayed(Duration.zero);

      // Then
      expect(viewModel.state.savedFilePath, equals(savedPath));
      expect(viewModel.state.status, equals(QrGeneratorStatus.success));
    });

    test('given no QR image and SaveQrRequestedEvent when dispatched then sets error state', () {
      // Given (no QR generated yet)

      // When
      viewModel.onEvent(const SaveQrRequestedEvent());

      // Then
      expect(viewModel.state.status, equals(QrGeneratorStatus.error));
      expect(viewModel.state.errorMessage, contains('No QR code image available'));
    });

    test('given DismissMessagesEvent when dispatched then clears error and success messages', () {
      // Given
      viewModel.onEvent(const GenerateQrRequestedEvent()); // Trigger error on empty input

      // When
      viewModel.onEvent(const DismissMessagesEvent());

      // Then
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.successMessage, isNull);
    });
  });
}
