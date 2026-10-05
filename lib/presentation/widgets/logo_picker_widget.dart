import 'dart:typed_data';
import 'package:flutter/material.dart';

class LogoPickerWidget extends StatelessWidget {
  final Uint8List? logoBytes;
  final VoidCallback onPickLogo;
  final VoidCallback onRemoveLogo;

  const LogoPickerWidget({
    super.key,
    required this.logoBytes,
    required this.onPickLogo,
    required this.onRemoveLogo,
  });

  @override
  Widget build(BuildContext context) {
    final hasLogo = logoBytes != null && logoBytes!.isNotEmpty;
    final logoSizeKb = hasLogo ? (logoBytes!.length / 1024).toStringAsFixed(1) : '0';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Center Logo (Optional)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (hasLogo)
                  Chip(
                    avatar: const Icon(Icons.check_circle, size: 16, color: Colors.green),
                    label: Text(
                      'Logo Attached ($logoSizeKb KB)',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.green.shade50,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasLogo)
              Column(
                children: [
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: MemoryImage(logoBytes!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('change_logo_button'),
                          onPressed: onPickLogo,
                          icon: const Icon(Icons.photo_library_outlined, size: 18),
                          label: const Text('Change Logo'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('remove_logo_button'),
                          onPressed: onRemoveLogo,
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Remove'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              OutlinedButton.icon(
                key: const Key('pick_logo_button'),
                onPressed: onPickLogo,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Select Logo Image'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
