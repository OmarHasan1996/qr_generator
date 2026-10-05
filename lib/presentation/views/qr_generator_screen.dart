import 'package:flutter/material.dart';

import '../state/qr_generator_event.dart';
import '../viewmodels/qr_generator_view_model.dart';
import '../widgets/logo_picker_widget.dart';
import '../widgets/qr_input_form.dart';
import '../widgets/qr_preview_card.dart';

class QrGeneratorScreen extends StatelessWidget {
  final QrGeneratorViewModel viewModel;

  const QrGeneratorScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final state = viewModel.state;

        // Show SnackBar when messages occur
        if (state.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            viewModel.onEvent(const DismissMessagesEvent());
          });
        } else if (state.successMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
            viewModel.onEvent(const DismissMessagesEvent());
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('QR Code Generator'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QrInputForm(
                  text: state.inputText,
                  onChanged: (val) => viewModel.onEvent(TextChangedEvent(val)),
                  onGenerate: () => viewModel.onEvent(const GenerateQrRequestedEvent()),
                  isGenerating: state.isGenerating,
                ),
                const SizedBox(height: 16),
                LogoPickerWidget(
                  logoBytes: state.logoBytes,
                  onPickLogo: () => viewModel.onEvent(const PickLogoRequestedEvent()),
                  onRemoveLogo: () => viewModel.onEvent(const RemoveLogoRequestedEvent()),
                ),
                const SizedBox(height: 16),
                QrPreviewCard(
                  qrImageBytes: state.qrImageBytes,
                  selectedDirectoryPath: state.selectedDirectoryPath,
                  onSelectDirectory: () => viewModel.onEvent(const SelectDirectoryRequestedEvent()),
                  onSave: () => viewModel.onEvent(const SaveQrRequestedEvent()),
                  isSaving: state.isSaving,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
