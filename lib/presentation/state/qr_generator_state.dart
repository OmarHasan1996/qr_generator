import 'dart:typed_data';

enum QrGeneratorStatus {
  initial,
  generating,
  success,
  saving,
  error,
}

class QrGeneratorState {
  final String inputText;
  final Uint8List? logoBytes;
  final Uint8List? qrImageBytes;
  final QrGeneratorStatus status;
  final String? errorMessage;
  final String? successMessage;
  final String? savedFilePath;
  final String? selectedDirectoryPath;

  const QrGeneratorState({
    this.inputText = '',
    this.logoBytes,
    this.qrImageBytes,
    this.status = QrGeneratorStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.savedFilePath,
    this.selectedDirectoryPath,
  });

  bool get isGenerating => status == QrGeneratorStatus.generating;
  bool get isSaving => status == QrGeneratorStatus.saving;
  bool get hasLogo => logoBytes != null && logoBytes!.isNotEmpty;
  bool get hasQrImage => qrImageBytes != null && qrImageBytes!.isNotEmpty;
  bool get isInputValid => inputText.trim().isNotEmpty;

  QrGeneratorState copyWith({
    String? inputText,
    Uint8List? logoBytes,
    Uint8List? qrImageBytes,
    QrGeneratorStatus? status,
    String? errorMessage,
    String? successMessage,
    String? savedFilePath,
    String? selectedDirectoryPath,
    bool clearLogo = false,
    bool clearQrImage = false,
    bool clearMessages = false,
    bool clearDirectory = false,
  }) {
    return QrGeneratorState(
      inputText: inputText ?? this.inputText,
      logoBytes: clearLogo ? null : (logoBytes ?? this.logoBytes),
      qrImageBytes: clearQrImage ? null : (qrImageBytes ?? this.qrImageBytes),
      status: status ?? this.status,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
      savedFilePath: savedFilePath ?? this.savedFilePath,
      selectedDirectoryPath: clearDirectory ? null : (selectedDirectoryPath ?? this.selectedDirectoryPath),
    );
  }
}
