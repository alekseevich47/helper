import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'CallMemo'**
  String get appTitle;

  /// No description provided for @tabCalls.
  ///
  /// In ru, this message translates to:
  /// **'Звонки'**
  String get tabCalls;

  /// No description provided for @tabCalendar.
  ///
  /// In ru, this message translates to:
  /// **'Календарь'**
  String get tabCalendar;

  /// No description provided for @tabNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get tabNotes;

  /// No description provided for @tabProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get tabProfile;

  /// No description provided for @noCalls.
  ///
  /// In ru, this message translates to:
  /// **'Нет записей звонков'**
  String get noCalls;

  /// No description provided for @noSummary.
  ///
  /// In ru, this message translates to:
  /// **'Резюме пока нет'**
  String get noSummary;

  /// No description provided for @noTranscription.
  ///
  /// In ru, this message translates to:
  /// **'Транскрипции пока нет'**
  String get noTranscription;

  /// No description provided for @noEvents.
  ///
  /// In ru, this message translates to:
  /// **'Нет событий'**
  String get noEvents;

  /// No description provided for @noNotes.
  ///
  /// In ru, this message translates to:
  /// **'Нет заметок'**
  String get noNotes;

  /// No description provided for @summary.
  ///
  /// In ru, this message translates to:
  /// **'Резюме'**
  String get summary;

  /// No description provided for @transcription.
  ///
  /// In ru, this message translates to:
  /// **'Транскрипция'**
  String get transcription;

  /// No description provided for @events.
  ///
  /// In ru, this message translates to:
  /// **'События'**
  String get events;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @autoTranscribe.
  ///
  /// In ru, this message translates to:
  /// **'Автотранскрипция'**
  String get autoTranscribe;

  /// No description provided for @notifyBeforeTranscribe.
  ///
  /// In ru, this message translates to:
  /// **'Спрашивать перед распознаванием'**
  String get notifyBeforeTranscribe;

  /// No description provided for @darkTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get lightTheme;

  /// No description provided for @systemTheme.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get systemTheme;

  /// No description provided for @play.
  ///
  /// In ru, this message translates to:
  /// **'Воспроизвести'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In ru, this message translates to:
  /// **'Пауза'**
  String get pause;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @newNote.
  ///
  /// In ru, this message translates to:
  /// **'Новая заметка'**
  String get newNote;

  /// No description provided for @editNote.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать заметку'**
  String get editNote;

  /// No description provided for @profile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profile;

  /// No description provided for @tariff.
  ///
  /// In ru, this message translates to:
  /// **'Тариф'**
  String get tariff;

  /// No description provided for @minutesUsed.
  ///
  /// In ru, this message translates to:
  /// **'Минут использовано'**
  String get minutesUsed;

  /// No description provided for @free.
  ///
  /// In ru, this message translates to:
  /// **'Бесплатный'**
  String get free;

  /// No description provided for @upgrade.
  ///
  /// In ru, this message translates to:
  /// **'Улучшить план'**
  String get upgrade;

  /// No description provided for @addFile.
  ///
  /// In ru, this message translates to:
  /// **'Добавить файл'**
  String get addFile;

  /// No description provided for @pullToRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Потяните, чтобы обновить'**
  String get pullToRefresh;

  /// No description provided for @processingFailed.
  ///
  /// In ru, this message translates to:
  /// **'Обработка не удалась'**
  String get processingFailed;

  /// No description provided for @unknown.
  ///
  /// In ru, this message translates to:
  /// **'Неизвестно'**
  String get unknown;

  /// No description provided for @comingSoon.
  ///
  /// In ru, this message translates to:
  /// **'Скоро'**
  String get comingSoon;

  /// No description provided for @audioNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Аудиофайл не найден'**
  String get audioNotFound;

  /// No description provided for @newCallRecorded.
  ///
  /// In ru, this message translates to:
  /// **'Записан новый звонок'**
  String get newCallRecorded;

  /// No description provided for @scanRecordings.
  ///
  /// In ru, this message translates to:
  /// **'Сканировать записи'**
  String get scanRecordings;

  /// No description provided for @scanFound.
  ///
  /// In ru, this message translates to:
  /// **'Найдена новая запись'**
  String get scanFound;

  /// No description provided for @scanNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Новых записей не найдено'**
  String get scanNotFound;

  /// No description provided for @callRecordingSetup.
  ///
  /// In ru, this message translates to:
  /// **'Системная автозапись звонков'**
  String get callRecordingSetup;

  /// No description provided for @callRecordingSetupSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'CallMemo читает файлы штатной записи приложения «Телефон»'**
  String get callRecordingSetupSubtitle;

  /// No description provided for @detectedBrand.
  ///
  /// In ru, this message translates to:
  /// **'Определённый бренд'**
  String get detectedBrand;

  /// No description provided for @openCallRecordingSettings.
  ///
  /// In ru, this message translates to:
  /// **'Открыть настройки записи'**
  String get openCallRecordingSettings;

  /// No description provided for @openPhoneApp.
  ///
  /// In ru, this message translates to:
  /// **'Открыть приложение «Телефон»'**
  String get openPhoneApp;

  /// No description provided for @callRecordingOpened.
  ///
  /// In ru, this message translates to:
  /// **'Открыты настройки (или звонилка). Включите автозапись вызовов.'**
  String get callRecordingOpened;

  /// No description provided for @callRecordingOpenFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть настройки. Следуйте инструкции ниже вручную.'**
  String get callRecordingOpenFailed;

  /// No description provided for @callRecordingMayBeUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'На многих прошивках для РФ/EU пункт автозаписи скрыт. Если его нет — системная автозапись недоступна на этом устройстве.'**
  String get callRecordingMayBeUnavailable;

  /// No description provided for @callRecordingStepsSamsung.
  ///
  /// In ru, this message translates to:
  /// **'1. Откройте «Телефон» → меню (⋮) → Настройки.\n2. Найдите «Запись вызовов» / «Запись разговоров».\n3. Включите «Автозапись» (все / неизвестные / выбранные контакты).\nЕсли пункта нет — на CSC для РФ его обычно нет; запись появляется после смены региона (например Индия/Таиланд/Вьетнам).'**
  String get callRecordingStepsSamsung;

  /// No description provided for @callRecordingStepsXiaomi.
  ///
  /// In ru, this message translates to:
  /// **'1. Откройте «Телефон» → Настройки → Запись звонков.\n2. Включите автозапись (все или выбранные номера).\nНа Global/EU часто стоит Google Dialer: запись вручную и с оповещением собеседника.\nДля полной автозаписи без beep нужна Mi Dialer (часто RU / Тайвань / Индия / Таиланд при первой настройке).'**
  String get callRecordingStepsXiaomi;

  /// No description provided for @callRecordingStepsOppo.
  ///
  /// In ru, this message translates to:
  /// **'1. Откройте «Телефон» или ODialer → Настройки → Запись вызовов.\n2. Включите автозапись.\nНа новых ColorOS/Realme UI иногда стоит Google Dialer без пункта — установите ODialer из Play и повторите.\nБерите EAC-версию, если покупаете под РФ.'**
  String get callRecordingStepsOppo;

  /// No description provided for @callRecordingStepsVivo.
  ///
  /// In ru, this message translates to:
  /// **'1. Откройте «Телефон» → Настройки.\n2. «Запись вызовов» / «Автозапись вызовов» → включите.\nОбычно доступна на фирменном диалере без уведомления собеседника.'**
  String get callRecordingStepsVivo;

  /// No description provided for @callRecordingStepsTecno.
  ///
  /// In ru, this message translates to:
  /// **'1. Настройки → SIM и сети / Настройки вызова → «Автозапись вызовов».\nИли: «Телефон» → Настройки → автозапись.\nНа HiOS/XOS функция чаще всего есть из коробки.'**
  String get callRecordingStepsTecno;

  /// No description provided for @callRecordingStepsHuawei.
  ///
  /// In ru, this message translates to:
  /// **'1. Откройте «Телефон» → Настройки → Запись звонков.\n2. Включите автозапись, если пункт есть.\nНа части Honor/Huawei модуль записи отключён — пункт появится только после установки фирменного recorder-модуля под вашу версию MagicOS/EMUI.'**
  String get callRecordingStepsHuawei;

  /// No description provided for @callRecordingStepsGoogle.
  ///
  /// In ru, this message translates to:
  /// **'1. «Телефон» (Google) → Настройки → Call Assist / Запись вызовов.\n2. Включите запись (где доступна по региону).\nАвтозапись не во всех странах. Обычно звучит оповещение собеседнику. На Pixel функция зависит от страны и версии приложения «Телефон».'**
  String get callRecordingStepsGoogle;

  /// No description provided for @callRecordingStepsMotorola.
  ///
  /// In ru, this message translates to:
  /// **'1. Откройте Google «Телефон» → Настройки → Запись вызовов.\n2. Включите, если пункт доступен в вашем регионе.\nИначе системной автозаписи нет — CallMemo не сможет собирать файлы звонков.'**
  String get callRecordingStepsMotorola;

  /// No description provided for @callRecordingStepsNothing.
  ///
  /// In ru, this message translates to:
  /// **'1. Google «Телефон» → Настройки → Запись вызовов.\n2. Включите при наличии пункта по региону.\nЕсли пункта нет — штатной автозаписи на устройстве нет.'**
  String get callRecordingStepsNothing;

  /// No description provided for @callRecordingStepsSony.
  ///
  /// In ru, this message translates to:
  /// **'1. Откройте приложение «Телефон» → Настройки.\n2. Ищите «Запись вызовов».\nЧасто используется Google Dialer с региональными ограничениями.'**
  String get callRecordingStepsSony;

  /// No description provided for @callRecordingStepsAsus.
  ///
  /// In ru, this message translates to:
  /// **'1. «Телефон» → Настройки → Запись вызовов / автозапись.\n2. Включите для всех или выбранных номеров.\nНа части моделей запись есть только в азиатских прошивках.'**
  String get callRecordingStepsAsus;

  /// No description provided for @callRecordingStepsNokia.
  ///
  /// In ru, this message translates to:
  /// **'1. Google «Телефон» → Настройки → Запись вызовов.\n2. Включите, если доступно в регионе.\nИначе системной автозаписи нет.'**
  String get callRecordingStepsNokia;

  /// No description provided for @callRecordingStepsGeneric.
  ///
  /// In ru, this message translates to:
  /// **'1. Откройте системное приложение «Телефон».\n2. Меню → Настройки → найдите «Запись вызовов» / «Автозапись».\n3. Включите автозапись.\nЕсли пункта нет — производитель отключил функцию для вашей прошивки; CallMemo работает только с файлами системной записи.'**
  String get callRecordingStepsGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
