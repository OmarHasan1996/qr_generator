import 'package:flutter/foundation.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/usecases/generate_qr_code_use_case.dart';
import '../../domain/usecases/pick_logo_image_use_case.dart';
import '../../domain/usecases/save_qr_code_use_case.dart';
import '../state/qr_generator_event.dart';
import '../state/qr_generator_state.dart';

class QrGeneratorViewModel extends ChangeNotifier {
  final GenerateQrCodeUseCase generateQrCodeUseCase;
  final PickLogoImageUseCase pickLogoImageUseCase;
  final SaveQrCodeUseCase saveQrCodeUseCase;
  final AppLogger logger;

  QrGeneratorState _state = const QrGeneratorState();

  QrGeneratorViewModel({
    required this.generateQrCodeUseCase,
    required this.pickLogoImageUseCase,
    required this.saveQrCodeUseCase,
    required this.logger,
  });

  QrGeneratorState get state => _state;

  void onEvent(QrGeneratorEvent event) {
    switch (event) {
      case TextChangedEvent(:final text):
        _onTextChanged(text);
      case PickLogoRequestedEvent():
        _onPickLogoRequested();
      case RemoveLogoRequestedEvent():
        _onRemoveLogoRequested();
      case GenerateQrRequestedEvent():
        _onGenerateQrRequested();
      case SelectDirectoryRequestedEvent():
        _onSelectDirectoryRequested();
      case SaveQrRequestedEvent():
        _onSaveQrRequested();
      case DismissMessagesEvent():
        _onDismissMessages();
    }
  }

  void _onTextChanged(String text) {
    logger.debug('ViewModel: Text changed', tag: 'ViewModel');
    _state = _state.copyWith(
      inputText: text,
      clearMessages: true,
    );
    notifyListeners();
  }

  Future<void> _onPickLogoRequested() async {
    logger.info('ViewModel: Pick logo requested', tag: 'ViewModel');
    try {
      final logoBytes = await pickLogoImageUseCase.execute();
      if (logoBytes != null) {
        _state = _state.copyWith(
          logoBytes: logoBytes,
          clearMessages: true,
        );
        notifyListeners();

        // Auto update QR code if valid input text exists
        if (_state.isInputValid) {
          await _onGenerateQrRequested();
        }
      }
    } catch (e, stackTrace) {
      logger.error('ViewModel: Pick logo failed', tag: 'ViewModel', error: e, stackTrace: stackTrace);
      _state = _state.copyWith(
        status: QrGeneratorStatus.error,
        errorMessage: 'Failed to pick image: $e',
      );
      notifyListeners();
    }
  }

  Future<void> _onRemoveLogoRequested() async {
    logger.info('ViewModel: Logo removal requested', tag: 'ViewModel');
    _state = _state.copyWith(
      clearLogo: true,
      clearMessages: true,
    );
    notifyListeners();

    // Auto update QR code if valid input text exists
    if (_state.isInputValid) {
      await _onGenerateQrRequested();
    }
  }

  Future<void> _onGenerateQrRequested() async {
    if (!_state.isInputValid) {
      _state = _state.copyWith(
        status: QrGeneratorStatus.error,
        errorMessage: 'Please enter text or URL for the QR code.',
      );
      notifyListeners();
      return;
    }

    logger.info('ViewModel: Generate QR code requested', tag: 'ViewModel');
    _state = _state.copyWith(
      status: QrGeneratorStatus.generating,
      clearMessages: true,
    );
    notifyListeners();

    try {
      final qrBytes = await generateQrCodeUseCase.execute(
        text: _state.inputText,
        logoBytes: _state.logoBytes,
      );

      _state = _state.copyWith(
        qrImageBytes: qrBytes,
        status: QrGeneratorStatus.success,
        successMessage: 'QR code generated successfully!',
      );
    } catch (e, stackTrace) {
      logger.error('ViewModel: Generate QR failed', tag: 'ViewModel', error: e, stackTrace: stackTrace);
      _state = _state.copyWith(
        status: QrGeneratorStatus.error,
        errorMessage: 'Failed to generate QR code: ${e.toString()}',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> _onSelectDirectoryRequested() async {
    logger.info('ViewModel: Select save directory requested', tag: 'ViewModel');
    try {
      final selectedPath = await saveQrCodeUseCase.selectSaveDirectory();
      if (selectedPath != null && selectedPath.isNotEmpty) {
        _state = _state.copyWith(
          selectedDirectoryPath: selectedPath,
          clearMessages: true,
        );
        notifyListeners();
      }
    } catch (e, stackTrace) {
      logger.error('ViewModel: Select directory failed', tag: 'ViewModel', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _onSaveQrRequested() async {
    if (!_state.hasQrImage) {
      _state = _state.copyWith(
        status: QrGeneratorStatus.error,
        errorMessage: 'No QR code image available to save.',
      );
      notifyListeners();
      return;
    }

    logger.info('ViewModel: Save QR code requested', tag: 'ViewModel');
    _state = _state.copyWith(
      status: QrGeneratorStatus.saving,
      clearMessages: true,
    );
    notifyListeners();

    try {
      final savedPath = await saveQrCodeUseCase.execute(
        imageBytes: _state.qrImageBytes!,
        customDirectory: _state.selectedDirectoryPath,
      );

      _state = _state.copyWith(
        status: QrGeneratorStatus.success,
        savedFilePath: savedPath,
        successMessage: 'QR code saved to $savedPath',
      );
    } catch (e, stackTrace) {
      logger.error('ViewModel: Save QR failed', tag: 'ViewModel', error: e, stackTrace: stackTrace);
      _state = _state.copyWith(
        status: QrGeneratorStatus.error,
        errorMessage: 'Failed to save QR code image: ${e.toString()}',
      );
    } finally {
      notifyListeners();
    }
  }

  void _onDismissMessages() {
    _state = _state.copyWith(clearMessages: true);
    notifyListeners();
  }
}
