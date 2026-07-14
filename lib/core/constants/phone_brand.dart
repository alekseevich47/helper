/// Семейства OEM для путей автозаписи и онбординга системной записи.
enum PhoneBrandFamily {
  samsung,
  xiaomi,
  oppo,
  vivo,
  tecno,
  huawei,
  google,
  motorola,
  nothing,
  sony,
  asus,
  nokia,
  unknown,
}

abstract final class PhoneBrand {
  static PhoneBrandFamily detect(String brandOrManufacturer) {
    final b = brandOrManufacturer.toLowerCase();
    if (b.contains('samsung')) return PhoneBrandFamily.samsung;
    if (b.contains('xiaomi') ||
        b.contains('redmi') ||
        b.contains('poco') ||
        b.contains('blackshark')) {
      return PhoneBrandFamily.xiaomi;
    }
    if (b.contains('oppo') ||
        b.contains('realme') ||
        b.contains('oneplus') ||
        b.contains('oplus')) {
      return PhoneBrandFamily.oppo;
    }
    if (b.contains('vivo') || b.contains('iqoo')) {
      return PhoneBrandFamily.vivo;
    }
    if (b.contains('tecno') ||
        b.contains('infinix') ||
        b.contains('itel') ||
        b.contains('transsion')) {
      return PhoneBrandFamily.tecno;
    }
    if (b.contains('huawei') || b.contains('honor')) {
      return PhoneBrandFamily.huawei;
    }
    if (b.contains('google') || b.contains('pixel')) {
      return PhoneBrandFamily.google;
    }
    if (b.contains('motorola') || b.contains('lenovo')) {
      return PhoneBrandFamily.motorola;
    }
    if (b.contains('nothing')) return PhoneBrandFamily.nothing;
    if (b.contains('sony')) return PhoneBrandFamily.sony;
    if (b.contains('asus') || b.contains('rog')) return PhoneBrandFamily.asus;
    if (b.contains('nokia') || b.contains('hmd')) return PhoneBrandFamily.nokia;
    return PhoneBrandFamily.unknown;
  }

  static String displayName(PhoneBrandFamily family) => switch (family) {
        PhoneBrandFamily.samsung => 'Samsung',
        PhoneBrandFamily.xiaomi => 'Xiaomi / Redmi / POCO',
        PhoneBrandFamily.oppo => 'OPPO / Realme / OnePlus',
        PhoneBrandFamily.vivo => 'Vivo / iQOO',
        PhoneBrandFamily.tecno => 'TECNO / Infinix / itel',
        PhoneBrandFamily.huawei => 'Huawei / Honor',
        PhoneBrandFamily.google => 'Google Pixel',
        PhoneBrandFamily.motorola => 'Motorola',
        PhoneBrandFamily.nothing => 'Nothing',
        PhoneBrandFamily.sony => 'Sony',
        PhoneBrandFamily.asus => 'ASUS',
        PhoneBrandFamily.nokia => 'Nokia',
        PhoneBrandFamily.unknown => 'Android',
      };

  /// На типичных РФ/глобальных прошивках автозапись часто скрыта.
  static bool mayLackStockAutoRecord(PhoneBrandFamily family) => switch (family) {
        PhoneBrandFamily.samsung ||
        PhoneBrandFamily.google ||
        PhoneBrandFamily.motorola ||
        PhoneBrandFamily.nothing ||
        PhoneBrandFamily.nokia ||
        PhoneBrandFamily.sony =>
          true,
        _ => false,
      };
}
