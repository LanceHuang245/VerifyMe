import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verifyme/l10n/generated/localizations.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(loc.confirm),
      content: Text(title),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Get.back();
          },
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Get.back();
          },
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
            foregroundColor:
                WidgetStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
          ),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
