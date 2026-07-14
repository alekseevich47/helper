// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'CallMemo';

  @override
  String get tabCalls => 'Звонки';

  @override
  String get tabCalendar => 'Календарь';

  @override
  String get tabNotes => 'Заметки';

  @override
  String get tabProfile => 'Профиль';

  @override
  String get noCalls => 'Нет записей звонков';

  @override
  String get noSummary => 'Резюме пока нет';

  @override
  String get noTranscription => 'Транскрипции пока нет';

  @override
  String get noEvents => 'Нет событий';

  @override
  String get noNotes => 'Нет заметок';

  @override
  String get summary => 'Резюме';

  @override
  String get transcription => 'Транскрипция';

  @override
  String get events => 'События';

  @override
  String get settings => 'Настройки';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Язык';

  @override
  String get autoTranscribe => 'Автотранскрипция';

  @override
  String get notifyBeforeTranscribe => 'Спрашивать перед распознаванием';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get systemTheme => 'Системная';

  @override
  String get play => 'Воспроизвести';

  @override
  String get pause => 'Пауза';

  @override
  String get retry => 'Повторить';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get cancel => 'Отмена';

  @override
  String get newNote => 'Новая заметка';

  @override
  String get editNote => 'Редактировать заметку';

  @override
  String get profile => 'Профиль';

  @override
  String get tariff => 'Тариф';

  @override
  String get minutesUsed => 'Минут использовано';

  @override
  String get free => 'Бесплатный';

  @override
  String get upgrade => 'Улучшить план';

  @override
  String get addFile => 'Добавить файл';

  @override
  String get pullToRefresh => 'Потяните, чтобы обновить';

  @override
  String get processingFailed => 'Обработка не удалась';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get audioNotFound => 'Аудиофайл не найден';

  @override
  String get newCallRecorded => 'Записан новый звонок';

  @override
  String get scanRecordings => 'Сканировать записи';

  @override
  String get scanFound => 'Найдена новая запись';

  @override
  String get scanNotFound => 'Новых записей не найдено';

  @override
  String get callRecordingSetup => 'Системная автозапись звонков';

  @override
  String get callRecordingSetupSubtitle =>
      'CallMemo читает файлы штатной записи приложения «Телефон»';

  @override
  String get detectedBrand => 'Определённый бренд';

  @override
  String get openCallRecordingSettings => 'Открыть настройки записи';

  @override
  String get openPhoneApp => 'Открыть приложение «Телефон»';

  @override
  String get callRecordingOpened =>
      'Открыты настройки (или звонилка). Включите автозапись вызовов.';

  @override
  String get callRecordingOpenFailed =>
      'Не удалось открыть настройки. Следуйте инструкции ниже вручную.';

  @override
  String get callRecordingMayBeUnavailable =>
      'На многих прошивках для РФ/EU пункт автозаписи скрыт. Если его нет — системная автозапись недоступна на этом устройстве.';

  @override
  String get callRecordingStepsSamsung =>
      '1. Откройте «Телефон» → меню (⋮) → Настройки.\n2. Найдите «Запись вызовов» / «Запись разговоров».\n3. Включите «Автозапись» (все / неизвестные / выбранные контакты).\nЕсли пункта нет — на CSC для РФ его обычно нет; запись появляется после смены региона (например Индия/Таиланд/Вьетнам).';

  @override
  String get callRecordingStepsXiaomi =>
      '1. Откройте «Телефон» → Настройки → Запись звонков.\n2. Включите автозапись (все или выбранные номера).\nНа Global/EU часто стоит Google Dialer: запись вручную и с оповещением собеседника.\nДля полной автозаписи без beep нужна Mi Dialer (часто RU / Тайвань / Индия / Таиланд при первой настройке).';

  @override
  String get callRecordingStepsOppo =>
      '1. Откройте «Телефон» или ODialer → Настройки → Запись вызовов.\n2. Включите автозапись.\nНа новых ColorOS/Realme UI иногда стоит Google Dialer без пункта — установите ODialer из Play и повторите.\nБерите EAC-версию, если покупаете под РФ.';

  @override
  String get callRecordingStepsVivo =>
      '1. Откройте «Телефон» → Настройки.\n2. «Запись вызовов» / «Автозапись вызовов» → включите.\nОбычно доступна на фирменном диалере без уведомления собеседника.';

  @override
  String get callRecordingStepsTecno =>
      '1. Настройки → SIM и сети / Настройки вызова → «Автозапись вызовов».\nИли: «Телефон» → Настройки → автозапись.\nНа HiOS/XOS функция чаще всего есть из коробки.';

  @override
  String get callRecordingStepsHuawei =>
      '1. Откройте «Телефон» → Настройки → Запись звонков.\n2. Включите автозапись, если пункт есть.\nНа части Honor/Huawei модуль записи отключён — пункт появится только после установки фирменного recorder-модуля под вашу версию MagicOS/EMUI.';

  @override
  String get callRecordingStepsGoogle =>
      '1. «Телефон» (Google) → Настройки → Call Assist / Запись вызовов.\n2. Включите запись (где доступна по региону).\nАвтозапись не во всех странах. Обычно звучит оповещение собеседнику. На Pixel функция зависит от страны и версии приложения «Телефон».';

  @override
  String get callRecordingStepsMotorola =>
      '1. Откройте Google «Телефон» → Настройки → Запись вызовов.\n2. Включите, если пункт доступен в вашем регионе.\nИначе системной автозаписи нет — CallMemo не сможет собирать файлы звонков.';

  @override
  String get callRecordingStepsNothing =>
      '1. Google «Телефон» → Настройки → Запись вызовов.\n2. Включите при наличии пункта по региону.\nЕсли пункта нет — штатной автозаписи на устройстве нет.';

  @override
  String get callRecordingStepsSony =>
      '1. Откройте приложение «Телефон» → Настройки.\n2. Ищите «Запись вызовов».\nЧасто используется Google Dialer с региональными ограничениями.';

  @override
  String get callRecordingStepsAsus =>
      '1. «Телефон» → Настройки → Запись вызовов / автозапись.\n2. Включите для всех или выбранных номеров.\nНа части моделей запись есть только в азиатских прошивках.';

  @override
  String get callRecordingStepsNokia =>
      '1. Google «Телефон» → Настройки → Запись вызовов.\n2. Включите, если доступно в регионе.\nИначе системной автозаписи нет.';

  @override
  String get callRecordingStepsGeneric =>
      '1. Откройте системное приложение «Телефон».\n2. Меню → Настройки → найдите «Запись вызовов» / «Автозапись».\n3. Включите автозапись.\nЕсли пункта нет — производитель отключил функцию для вашей прошивки; CallMemo работает только с файлами системной записи.';
}
