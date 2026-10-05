sealed class QrGeneratorEvent {
  const QrGeneratorEvent();
}

class TextChangedEvent extends QrGeneratorEvent {
  final String text;
  const TextChangedEvent(this.text);
}

class PickLogoRequestedEvent extends QrGeneratorEvent {
  const PickLogoRequestedEvent();
}

class RemoveLogoRequestedEvent extends QrGeneratorEvent {
  const RemoveLogoRequestedEvent();
}

class GenerateQrRequestedEvent extends QrGeneratorEvent {
  const GenerateQrRequestedEvent();
}

class SelectDirectoryRequestedEvent extends QrGeneratorEvent {
  const SelectDirectoryRequestedEvent();
}

class SaveQrRequestedEvent extends QrGeneratorEvent {
  const SaveQrRequestedEvent();
}

class DismissMessagesEvent extends QrGeneratorEvent {
  const DismissMessagesEvent();
}
