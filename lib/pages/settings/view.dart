import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:verifyme/l10n/generated/localizations.dart';
import 'package:verifyme/pages/settings/webdav_settings.dart';
import 'package:verifyme/pages/settings/widgets.dart';
import 'package:verifyme/utils/generate/controller.dart';
import 'package:verifyme/utils/notify.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final GenerateController totpController = Get.find();
  final GetStorage _box = GetStorage();
  String _themeMode = 'system';
  bool _selectedMonet = true;
  late String _languageCode;
  Color _currentColor = const Color(0xff443a49);

  final List<Map<String, String>> _languages = [
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'it', 'name': 'Italiano'},
    {'code': 'ru', 'name': 'Русский'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'zh', 'name': '中文 (简体)'},
    {'code': 'zh_TW', 'name': '中文 (繁体)'},
  ];

  @override
  void initState() {
    super.initState();
    _themeMode = _box.read('themeMode') ?? 'system';
    _languageCode = _box.read('languageCode') ?? 'en';
    final int? storedColor = _box.read('colorSeed');
    if (storedColor != null) {
      _currentColor = Color(storedColor);
    }
    if (Platform.isIOS) {
      _selectedMonet = false;
    } else {
      _selectedMonet = _box.read('monetStatus') ?? true;
    }
  }

  void _changeLanguage(String languageCode) {
    final parts = languageCode.split('_');
    final locale =
        parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
    Get.updateLocale(locale);
    setState(() => _languageCode = languageCode);
    _box.write('languageCode', languageCode);
  }

  void _saveThemeMode(String themeMode) {
    setState(() => _themeMode = themeMode);
    _box.write('themeMode', themeMode);
    Get.changeThemeMode(
      themeMode == 'system'
          ? ThemeMode.system
          : themeMode == 'light'
              ? ThemeMode.light
              : ThemeMode.dark,
    );
  }

  void _onMonetChanged(bool? value) {
    if (value == null || !mounted) return;
    setState(() => _selectedMonet = value);
    _box.write('monetStatus', value);
    showNotification(AppLocalizations.of(context).effective_after_reboot);
  }

  void _onCustomColorTapped() {
    if (_selectedMonet) return;
    showColorPickerDialog(context, _currentColor, (color) {
      setState(() => _currentColor = color);
      _box.write('colorSeed', _currentColor.value);
      showNotification(AppLocalizations.of(context).effective_after_reboot);
    });
  }

  Future<void> _exportData() async {
    if (await _requestPermission()) {
      try {
        final directory = await _getDirectory();
        final file = File('${directory.path}/totp_list.json');
        final jsonString = jsonEncode(totpController.totpList);
        await file.writeAsString(jsonString);
        if (mounted) {
          showNotification(
              '${AppLocalizations.of(context).export_to} ${file.path}');
        }
      } catch (e) {
        if (mounted) {
          showNotification(
              '${AppLocalizations.of(context).failed_to_export_data}: $e');
        }
      }
    } else {
      if (mounted) {
        showNotification(AppLocalizations.of(context).no_storage_permission);
      }
    }
  }

  Future<Directory> _getDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    throw UnsupportedError('Unsupported platform');
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      return await Permission.manageExternalStorage.request().isGranted;
    } else if (Platform.isIOS) {
      return await Permission.storage.request().isGranted;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bool isPlatformIos = Platform.isIOS;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(loc.settings),
            backgroundColor: theme.colorScheme.surface,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: _SettingsGroup(
              title: loc.theme,
              children: [
                _buildThemeSelector(loc, theme),
                if (!isPlatformIos) _buildMonetSwitch(loc, theme),
                _buildCustomColorSelector(loc, theme),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _SettingsGroup(
              title: loc.general,
              children: [
                _buildLanguageSelector(loc, theme),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _SettingsGroup(
              title: loc.data,
              children: [
                ListTile(
                  title: Text(loc.webdav_title),
                  leading: const Icon(Icons.cloud_upload_outlined),
                  onTap: () => Get.to(() => const WebDavSettingsPage()),
                ),
                ListTile(
                  title: Text(loc.export_data),
                  leading: const Icon(Icons.upload_file_outlined),
                  enabled: totpController.totpList.isNotEmpty,
                  onTap: _exportData,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _SettingsGroup(
              title: loc.about,
              children: [
                ListTile(
                  title: Text(loc.about),
                  leading: const Icon(Icons.info_outline),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => buildAboutDialog(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(AppLocalizations loc, ThemeData theme) {
    return ExpansionTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: Text(loc.theme),
      subtitle: Text(
        _themeMode == 'system'
            ? loc.follow_system
            : _themeMode == 'light'
                ? loc.light
                : loc.dark,
      ),
      children: [
        RadioListTile<String>(
          title: Text(loc.follow_system),
          value: 'system',
          groupValue: _themeMode,
          onChanged: (v) => _saveThemeMode(v!),
        ),
        RadioListTile<String>(
          title: Text(loc.light),
          value: 'light',
          groupValue: _themeMode,
          onChanged: (v) => _saveThemeMode(v!),
        ),
        RadioListTile<String>(
          title: Text(loc.dark),
          value: 'dark',
          groupValue: _themeMode,
          onChanged: (v) => _saveThemeMode(v!),
        ),
      ],
    );
  }

  Widget _buildMonetSwitch(AppLocalizations loc, ThemeData theme) {
    return SwitchListTile(
      title: Text(loc.monet_color),
      subtitle: Text(loc.effective_after_reboot),
      secondary: const Icon(Icons.color_lens_outlined),
      value: _selectedMonet,
      onChanged: _onMonetChanged,
    );
  }

  Widget _buildCustomColorSelector(AppLocalizations loc, ThemeData theme) {
    return ListTile(
      title: Text(loc.custom_color),
      subtitle: Text(loc.effective_after_reboot),
      leading: const Icon(Icons.palette_outlined),
      enabled: !_selectedMonet,
      onTap: _onCustomColorTapped,
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _selectedMonet ? theme.disabledColor : _currentColor,
          shape: BoxShape.circle,
          border: Border.all(color: theme.dividerColor),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(AppLocalizations loc, ThemeData theme) {
    final currentLangName = _languages.firstWhere(
        (lang) => lang['code'] == _languageCode,
        orElse: () => {'name': ''})['name'];
    return ExpansionTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(loc.language),
      subtitle: Text(currentLangName ?? ''),
      children: _languages.map((lang) {
        return RadioListTile<String>(
          title: Text(lang['name']!),
          value: lang['code']!,
          groupValue: _languageCode,
          onChanged: (v) => _changeLanguage(v!),
        );
      }).toList(),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              title,
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
