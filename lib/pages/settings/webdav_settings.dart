import 'dart:convert';
import 'package:get/get.dart';
import 'package:verifyme/utils/generate/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webdav_client/webdav_client.dart';
import 'package:verifyme/utils/notify.dart';
import 'package:verifyme/l10n/generated/localizations.dart';

class WebDavSettingsPage extends StatefulWidget {
  const WebDavSettingsPage({super.key});

  @override
  State<WebDavSettingsPage> createState() => _WebDavSettingsPageState();
}

class _WebDavSettingsPageState extends State<WebDavSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _secureStorage = const FlutterSecureStorage();

  late TextEditingController _urlController;
  late TextEditingController _userController;
  late TextEditingController _passController;

  bool _loading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _userController = TextEditingController();
    _passController = TextEditingController();
    _loadSettings();
    _urlController.addListener(_onFormChanged);
    _userController.addListener(_onFormChanged);
    _passController.addListener(_onFormChanged);
  }

  Future<void> _loadSettings() async {
    _urlController.text = await _secureStorage.read(key: 'webdav_url') ?? '';
    _userController.text = await _secureStorage.read(key: 'webdav_user') ?? '';
    _passController.text = await _secureStorage.read(key: 'webdav_pass') ?? '';
    _onFormChanged();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    final valid = _urlController.text.trim().isNotEmpty &&
        _userController.text.trim().isNotEmpty &&
        _passController.text.trim().isNotEmpty;
    if (valid != _isFormValid) {
      setState(() {
        _isFormValid = valid;
      });
    }
  }

  Client get client => newClient(
        _urlController.text.trim(),
        user: _userController.text.trim(),
        password: _passController.text,
      );

  Future<void> _saveSettings() async {
    await _secureStorage.write(
        key: 'webdav_url', value: _urlController.text.trim());
    await _secureStorage.write(
        key: 'webdav_user', value: _userController.text.trim());
    await _secureStorage.write(key: 'webdav_pass', value: _passController.text);
  }

  Future<void> _runWithLoading(Future<void> Function() action) async {
    setState(() => _loading = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _testConnection() async {
    await _saveSettings();
    final loc = AppLocalizations.of(context);
    try {
      await client.ping();
      showNotification(loc.webdav_connect_success);
    } catch (e) {
      showNotification('${loc.webdav_connect_fail}: $e');
    }
  }

  Future<void> _backupToWebDav() async {
    await _saveSettings();
    final loc = AppLocalizations.of(context);
    try {
      final controller = Get.find<GenerateController>();
      final data = controller.totpList.toList();
      if (data.isEmpty) {
        showNotification(loc.webdav_no_data);
        return;
      }
      await client.write(
        '/totp_list.json',
        utf8.encode(jsonEncode(data)),
      );
      showNotification(loc.webdav_backup_success);
    } catch (e) {
      showNotification('${loc.webdav_backup_fail}: $e');
    }
  }

  Future<void> _restoreFromWebDav() async {
    await _saveSettings();
    final loc = AppLocalizations.of(context);
    try {
      final bytes = await client.read('/totp_list.json');
      final jsonData = jsonDecode(utf8.decode(bytes));
      final controller = Get.find<GenerateController>();
      final List<dynamic> jsonList = jsonData;
      controller.totpList.assignAll(
        jsonList.map((e) => Map<String, dynamic>.from(e)).toList(),
      );
      await controller.saveList();
      showNotification(
          '${loc.webdav_restore_success}, ${loc.webdav_reboot_tip}');
    } catch (e) {
      showNotification('${loc.webdav_restore_fail}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.webdav_title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: loc.webdav_address,
                  hintText: loc.webdav_address_hint,
                  prefixIcon: const Icon(Icons.cloud),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? loc.webdav_input_address : null,
                enabled: !_loading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: loc.webdav_username,
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
                enabled: !_loading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(
                  labelText: loc.webdav_password,
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
                enabled: !_loading,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.link),
                      label: Text(loc.webdav_connect),
                      onPressed: _isFormValid && !_loading
                          ? () => _runWithLoading(_testConnection)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.backup),
                      label: Text(loc.webdav_backup),
                      onPressed: _isFormValid && !_loading
                          ? () => _runWithLoading(_backupToWebDav)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.restore),
                      label: Text(loc.webdav_restore),
                      onPressed: _isFormValid && !_loading
                          ? () => _runWithLoading(_restoreFromWebDav)
                          : null,
                    ),
                  ),
                ],
              ),
              if (_loading) ...[
                const SizedBox(height: 32),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
