// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CallMemo';

  @override
  String get tabCalls => 'Calls';

  @override
  String get tabCalendar => 'Calendar';

  @override
  String get tabNotes => 'Notes';

  @override
  String get tabProfile => 'Profile';

  @override
  String get noCalls => 'No call recordings';

  @override
  String get noSummary => 'No summary yet';

  @override
  String get noTranscription => 'No transcription yet';

  @override
  String get noEvents => 'No events';

  @override
  String get noNotes => 'No notes';

  @override
  String get summary => 'Summary';

  @override
  String get transcription => 'Transcription';

  @override
  String get events => 'Events';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get autoTranscribe => 'Auto-transcribe';

  @override
  String get notifyBeforeTranscribe => 'Ask before transcription';

  @override
  String get darkTheme => 'Dark';

  @override
  String get lightTheme => 'Light';

  @override
  String get systemTheme => 'System';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get newNote => 'New note';

  @override
  String get editNote => 'Edit note';

  @override
  String get profile => 'Profile';

  @override
  String get tariff => 'Plan';

  @override
  String get minutesUsed => 'Minutes used';

  @override
  String get free => 'Free';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get addFile => 'Add file';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get processingFailed => 'Processing failed';

  @override
  String get unknown => 'Unknown';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get audioNotFound => 'Audio file not found';

  @override
  String get newCallRecorded => 'New call recorded';

  @override
  String get scanRecordings => 'Scan recordings';

  @override
  String get scanFound => 'New recording found';

  @override
  String get scanNotFound => 'No new recordings found';

  @override
  String get callRecordingSetup => 'System call auto-recording';

  @override
  String get callRecordingSetupSubtitle =>
      'CallMemo reads files from the stock Phone app recorder';

  @override
  String get detectedBrand => 'Detected brand';

  @override
  String get openCallRecordingSettings => 'Open recording settings';

  @override
  String get openPhoneApp => 'Open Phone app';

  @override
  String get callRecordingOpened =>
      'Opened settings (or dialer). Enable auto-record for calls.';

  @override
  String get callRecordingOpenFailed =>
      'Could not open settings. Follow the steps below manually.';

  @override
  String get callRecordingMayBeUnavailable =>
      'On many RU/EU firmwares auto-record is hidden. If the option is missing, system auto-recording is not available on this device.';

  @override
  String get callRecordingStepsSamsung =>
      '1. Open Phone → menu (⋮) → Settings.\n2. Find Call recording / Record calls.\n3. Enable Auto record (all / unknown / selected).\nIf missing — typical for RU CSC; recording appears after changing region (e.g. India/Thailand/Vietnam).';

  @override
  String get callRecordingStepsXiaomi =>
      '1. Open Phone → Settings → Call recording.\n2. Enable auto-record (all or selected numbers).\nGlobal/EU often use Google Dialer: manual record with a disclosure tone.\nFull silent auto-record needs Mi Dialer (often RU / Taiwan / India / Thailand on first setup).';

  @override
  String get callRecordingStepsOppo =>
      '1. Open Phone or ODialer → Settings → Call recording.\n2. Enable auto-record.\nNewer ColorOS/Realme UI may ship Google Dialer without the option — install ODialer from Play and retry.\nPrefer EAC builds for Russia.';

  @override
  String get callRecordingStepsVivo =>
      '1. Open Phone → Settings.\n2. Call recording / Auto record → enable.\nUsually available in the OEM dialer without notifying the other party.';

  @override
  String get callRecordingStepsTecno =>
      '1. Settings → SIM & network / Call settings → Auto record calls.\nOr: Phone → Settings → auto-record.\nOn HiOS/XOS this is usually available out of the box.';

  @override
  String get callRecordingStepsHuawei =>
      '1. Open Phone → Settings → Call recording.\n2. Enable auto-record if present.\nOn some Honor/Huawei devices the recorder module is disabled — install the matching MagicOS/EMUI recorder module first.';

  @override
  String get callRecordingStepsGoogle =>
      '1. Google Phone → Settings → Call Assist / Call recording.\n2. Enable where available by region.\nAuto-record is not available everywhere. Callers are often notified. Depends on country and Phone app version.';

  @override
  String get callRecordingStepsMotorola =>
      '1. Open Google Phone → Settings → Call recording.\n2. Enable if available in your region.\nOtherwise there is no system auto-record — CallMemo cannot collect call files.';

  @override
  String get callRecordingStepsNothing =>
      '1. Google Phone → Settings → Call recording.\n2. Enable if the option exists for your region.\nIf missing, stock auto-record is not available.';

  @override
  String get callRecordingStepsSony =>
      '1. Open Phone → Settings.\n2. Look for Call recording.\nOften uses Google Dialer with regional limits.';

  @override
  String get callRecordingStepsAsus =>
      '1. Phone → Settings → Call recording / auto-record.\n2. Enable for all or selected numbers.\nOn some models only Asian firmware includes it.';

  @override
  String get callRecordingStepsNokia =>
      '1. Google Phone → Settings → Call recording.\n2. Enable if available in your region.\nOtherwise system auto-record is unavailable.';

  @override
  String get callRecordingStepsGeneric =>
      '1. Open the system Phone app.\n2. Menu → Settings → find Call recording / Auto-record.\n3. Enable auto-record.\nIf the option is missing, the OEM disabled it for your firmware; CallMemo only works with system recording files.';
}
