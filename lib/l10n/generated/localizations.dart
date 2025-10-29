import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_de.dart';
import 'localizations_en.dart';
import 'localizations_es.dart';
import 'localizations_fr.dart';
import 'localizations_it.dart';
import 'localizations_ja.dart';
import 'localizations_ru.dart';
import 'localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ru'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @follow_system.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get follow_system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @export_data.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get export_data;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @monet_color.
  ///
  /// In en, this message translates to:
  /// **'Monet Color'**
  String get monet_color;

  /// No description provided for @effective_after_reboot.
  ///
  /// In en, this message translates to:
  /// **'Effective after reboot app'**
  String get effective_after_reboot;

  /// No description provided for @code_has_been_copied.
  ///
  /// In en, this message translates to:
  /// **'Code has been copied to clipboard'**
  String get code_has_been_copied;

  /// No description provided for @scan_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scan_qr_code;

  /// No description provided for @enter_manually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get enter_manually;

  /// No description provided for @import_json.
  ///
  /// In en, this message translates to:
  /// **'Import from JSON'**
  String get import_json;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the data? It is not recoverable after deletion.'**
  String get are_you_sure;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @input.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get input;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @secret.
  ///
  /// In en, this message translates to:
  /// **'Secret'**
  String get secret;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @algorithm.
  ///
  /// In en, this message translates to:
  /// **'Algorithm'**
  String get algorithm;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @failed_to_add.
  ///
  /// In en, this message translates to:
  /// **'Failed to add. Please check the parameters and try again.'**
  String get failed_to_add;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @issuer.
  ///
  /// In en, this message translates to:
  /// **'Issuer'**
  String get issuer;

  /// No description provided for @no_storage_permission.
  ///
  /// In en, this message translates to:
  /// **'No storage permission'**
  String get no_storage_permission;

  /// No description provided for @export_to.
  ///
  /// In en, this message translates to:
  /// **'Export to'**
  String get export_to;

  /// No description provided for @failed_to_export_data.
  ///
  /// In en, this message translates to:
  /// **'Failed to export data'**
  String get failed_to_export_data;

  /// No description provided for @unsupported_platform.
  ///
  /// In en, this message translates to:
  /// **'Unsupported platform'**
  String get unsupported_platform;

  /// No description provided for @import_successfully.
  ///
  /// In en, this message translates to:
  /// **'Import successfully'**
  String get import_successfully;

  /// No description provided for @file_selection_cancelled.
  ///
  /// In en, this message translates to:
  /// **'File selection cancelled'**
  String get file_selection_cancelled;

  /// No description provided for @failed_to_import.
  ///
  /// In en, this message translates to:
  /// **'Failed to import'**
  String get failed_to_import;

  /// No description provided for @custom_color.
  ///
  /// In en, this message translates to:
  /// **'Custom Theme Color'**
  String get custom_color;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// No description provided for @webdav_title.
  ///
  /// In en, this message translates to:
  /// **'WebDAV Settings'**
  String get webdav_title;

  /// No description provided for @webdav_address.
  ///
  /// In en, this message translates to:
  /// **'WebDAV Address'**
  String get webdav_address;

  /// No description provided for @webdav_address_hint.
  ///
  /// In en, this message translates to:
  /// **'Please enter the WebDAV server address'**
  String get webdav_address_hint;

  /// No description provided for @webdav_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get webdav_username;

  /// No description provided for @webdav_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get webdav_password;

  /// No description provided for @webdav_connect.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get webdav_connect;

  /// No description provided for @webdav_backup.
  ///
  /// In en, this message translates to:
  /// **'Backup to WebDAV'**
  String get webdav_backup;

  /// No description provided for @webdav_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore from WebDAV'**
  String get webdav_restore;

  /// No description provided for @webdav_connect_success.
  ///
  /// In en, this message translates to:
  /// **'Connection successful'**
  String get webdav_connect_success;

  /// No description provided for @webdav_connect_fail.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get webdav_connect_fail;

  /// No description provided for @webdav_no_data.
  ///
  /// In en, this message translates to:
  /// **'No data to backup'**
  String get webdav_no_data;

  /// No description provided for @webdav_backup_success.
  ///
  /// In en, this message translates to:
  /// **'Backup successful'**
  String get webdav_backup_success;

  /// No description provided for @webdav_backup_fail.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get webdav_backup_fail;

  /// No description provided for @webdav_restore_success.
  ///
  /// In en, this message translates to:
  /// **'Restore successful'**
  String get webdav_restore_success;

  /// No description provided for @webdav_restore_fail.
  ///
  /// In en, this message translates to:
  /// **'Restore failed'**
  String get webdav_restore_fail;

  /// No description provided for @webdav_input_address.
  ///
  /// In en, this message translates to:
  /// **'Please enter the WebDAV address'**
  String get webdav_input_address;

  /// No description provided for @webdav_reboot_tip.
  ///
  /// In en, this message translates to:
  /// **'Restart the app'**
  String get webdav_reboot_tip;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @import_warning.
  ///
  /// In en, this message translates to:
  /// **'This operation will overwrite the current data and only supports files exported by VerifyMe. Do you want to continue?'**
  String get import_warning;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it', 'ja', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
