import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:verifyme/constants/app.dart';
import 'package:verifyme/l10n/generated/localizations.dart';
import 'package:verifyme/utils/notify.dart';

AboutDialog buildAboutDialog() {
  return const AboutDialog(
    applicationVersion: AppConstants.appVersion,
    applicationName: AppConstants.appName,
    applicationLegalese: "Copyright© 2025 Lance Huang",
  );
}

// 颜色选择对话框
void showColorPickerDialog(
    BuildContext context, Color currentColor, Function(Color) onColorSelected) {
  Color pickerColor = currentColor;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context).custom_color),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => pickerColor = color,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            onPressed: () {
              Get.back();
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
              foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary),
            ),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
            onPressed: () {
              onColorSelected(pickerColor);
              Get.back();
              showNotification(
                  AppLocalizations.of(context).effective_after_reboot);
            },
          ),
        ],
      );
    },
  );
}
