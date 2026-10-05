import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QrPreviewCard extends StatelessWidget {
  final Uint8List? qrImageBytes;
  final String? selectedDirectoryPath;
  final VoidCallback onSelectDirectory;
  final VoidCallback onSave;
  final bool isSaving;

  const QrPreviewCard({
    super.key,
    required this.qrImageBytes,
    required this.selectedDirectoryPath,
    required this.onSelectDirectory,
    required this.onSave,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = qrImageBytes != null && qrImageBytes!.isNotEmpty;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Generated QR Code',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (hasImage) ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(12),
                child: Image.memory(
                  qrImageBytes!,
                  width: 240,
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              if (!kIsWeb) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDirectoryPath != null
                            ? 'Save location: $selectedDirectoryPath'
                            : 'Save location: Default storage',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      key: const Key('select_directory_button'),
                      onPressed: onSelectDirectory,
                      icon: const Icon(Icons.folder_open, size: 18),
                      label: const Text('Change'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              ElevatedButton.icon(
                key: const Key('download_qr_button'),
                onPressed: isSaving ? null : onSave,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download),
                label: Text(isSaving ? 'Saving...' : 'Download QR Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ] else
              Container(
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_2,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your generated QR code will appear here',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
