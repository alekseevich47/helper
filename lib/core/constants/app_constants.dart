/// Пути автозаписи звонков по брендам.
/// Fallback: MediaStore `audio/*` с фильтром по `DATE_MODIFIED` (~5 мин).
abstract final class BrandPaths {
  static const samsung = 'Recordings/Call';
  static const xiaomi = 'MIUI/sound_recorder/call_rec';
  static const oppo = 'ColorOS/PhoneRecords';

  /// TECNO / Infinix / itel (Transsion HiOS) — несколько типичных папок.
  static const List<String> tecno = [
    'Recordings/Call',
    'Recordings/CallRecordings',
    'PhoneRecord',
    'CallRecord',
    'Sounds/CallRec',
    'Music/PhoneRecord',
    'Record/Call',
    'Call recordings',
    'Recordings',
  ];

  /// Общий обход, если бренд неизвестен или папка бренда пуста.
  static const List<String> fallbackScan = [
    samsung,
    xiaomi,
    oppo,
    ...tecno,
    'Music',
    'Call',
  ];
}

/// Лимиты минут распознавания в месяц (PocketBase `minutes_limit`).
abstract final class TariffLimits {
  static const free = 60;
  static const basic = 300;
  // pro — безлимит (большое число на сервере).
}
