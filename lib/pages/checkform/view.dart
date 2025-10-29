import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/generate/controller.dart';
import 'package:verifyme/l10n/generated/localizations.dart';

class CheckFormPage extends StatefulWidget {
  final String resultUrl;
  const CheckFormPage({super.key, required this.resultUrl});

  @override
  State<CheckFormPage> createState() => _CheckFormPageState();
}

class _CheckFormPageState extends State<CheckFormPage> {
  final GenerateController gController = Get.find<GenerateController>();
  final TextEditingController lengthController =
      TextEditingController(text: '6');

  String selectedAlgorithm = 'SHA-1';
  String _secret = '';
  String _issuer = '';
  String _accountName = '';
  String _mode = '';

  @override
  void initState() {
    super.initState();
    _parseUrl();
  }

  void _parseUrl() {
    final uri = Uri.parse(widget.resultUrl);
    _secret = uri.queryParameters['secret'] ?? '';
    _issuer = uri.queryParameters['issuer'] ?? '';
    _accountName = uri.pathSegments.isNotEmpty
        ? uri.pathSegments.last.split(':').last
        : '';

    final totpMatch = RegExp(r'otpauth://(\w+)/').firstMatch(widget.resultUrl);
    _mode = (totpMatch != null ? totpMatch.group(1) : '')?.toUpperCase() ?? '';
  }

  @override
  void dispose() {
    lengthController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    await gController.add(
      _accountName,
      _secret.toUpperCase(),
      selectedAlgorithm,
      lengthController.text,
      _mode,
    );
    Get.back();
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
        title: Text(loc.confirm),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildGroupTitle(loc.details, theme),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  title: Text(loc.issuer),
                  subtitle: Text(_issuer),
                ),
                ListTile(
                  title: Text(loc.account),
                  subtitle: Text(_accountName),
                ),
                ListTile(
                  title: Text(loc.secret),
                  subtitle: Text(_secret.toUpperCase()),
                  dense: true,
                ),
                ListTile(
                  title: Text(loc.mode),
                  subtitle: Text(_mode),
                ),
              ],
            ),
          ),
          _buildGroupTitle(loc.options, theme),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedAlgorithm,
                    items: <String>['SHA-1', 'SHA-256', 'SHA-512']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
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
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: lengthController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: loc.length,
                      border: inputBorder,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _onConfirm,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(loc.confirm),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGroupTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
