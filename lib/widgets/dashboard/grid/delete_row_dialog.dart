import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_ui/providers/translation_provider.dart';
import 'package:intl_ui/widgets/common/button.dart';

class DeleteRowDialog extends ConsumerWidget {
  final String translationKey;
  final VoidCallback deleteCallback;

  const DeleteRowDialog({
    required this.translationKey,
    required this.deleteCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateTranslationKey =
        ref.read(TranslationProvider.provider.notifier).updateTranslationKey;

    return AlertDialog(
      content: Text(
          'Are you sure you want to delete all corresponding translations for ${translationKey}?'),
      actions: [
        Button(
          onPressed: () => Navigator.pop(context),
          color: Colors.grey,
          child: const Text('no'),
        ),
        Button(
          onPressed: () {
            updateTranslationKey(oldTranslationKey: translationKey);
            deleteCallback();
            Navigator.pop(context);
          },
          color: Colors.red,
          child: const Text('yes'),
        ),
      ],
    );
  }
}
