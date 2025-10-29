import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verifyme/utils/generate/controller.dart';
import 'package:verifyme/l10n/generated/localizations.dart';

class EditForm extends StatefulWidget {
  const EditForm({
    super.key,
    required this.accountName,
    required this.secret,
    required this.algorithm,
    required this.length,
    required this.mode,
    required this.isEdit,
  });

  final String accountName;
  final String secret;
  final String algorithm;
  final String length;
  final String mode;
  final bool isEdit;

  @override
  EditFormState createState() => EditFormState();
}

class EditFormState extends State<EditForm> {
  final GenerateController gController = Get.find<GenerateController>();

  late TextEditingController accountNameController;
  late TextEditingController secretController;
  late TextEditingController lengthController;

  late String selectedAlgorithm;
  late String selectedMode;

  final List<String> algorithms = ['SHA-1', 'SHA-256', 'SHA-512'];
  final List<String> modes = ['TOTP', 'HOTP'];

  @override
  void initState() {
    super.initState();
    accountNameController = TextEditingController(text: widget.accountName);
    secretController = TextEditingController(text: widget.secret);
    lengthController = TextEditingController(text: widget.length);

    selectedAlgorithm = widget.algorithm;
    selectedMode = widget.mode;
  }

  @override
  void dispose() {
    accountNameController.dispose();
    secretController.dispose();
    lengthController.dispose();
    super.dispose();
  }

  void _showErrorDialog() {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.error),
        content: Text(loc.failed_to_add),
        actions: <Widget>[
          TextButton(
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Future<void> _saveForm() async {
    final nameText = accountNameController.text.trim();
    final secretText = secretController.text.replaceAll(" ", "").toUpperCase();
    final lengthText = lengthController.text.trim();

    if (nameText.isEmpty || secretText.isEmpty) {
      _showErrorDialog();
      return;
    }

    final success = await gController.add(
      nameText,
      secretText,
      selectedAlgorithm,
      lengthText,
      selectedMode,
      oldSecret: widget.isEdit ? widget.secret : null,
    );

    if (success) {
      Get.back();
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? loc.edit : loc.input),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildGroupTitle(loc.mode, theme),
          DropdownButtonFormField<String>(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            value: selectedMode,
            items: modes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  selectedMode = newValue;
                });
              }
            },
            decoration: InputDecoration(
              border: inputBorder,
            ),
          ),
          const SizedBox(height: 16),
          _buildGroupTitle(loc.details, theme),
          TextFormField(
            controller: accountNameController,
            decoration: InputDecoration(
              labelText: loc.account,
              border: inputBorder,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: secretController,
            decoration: InputDecoration(
              labelText: loc.secret,
              border: inputBorder,
            ),
          ),
          const SizedBox(height: 16),
          _buildGroupTitle(loc.options, theme),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  value: selectedAlgorithm,
                  items: algorithms.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedAlgorithm = newValue;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: loc.algorithm,
                    border: inputBorder,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: lengthController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: loc.length,
                    border: inputBorder,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saveForm,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(MaterialLocalizations.of(context).saveButtonLabel),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGroupTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
