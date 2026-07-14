import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/constants/phone_brand.dart';
import '../../core/l10n/app_localizations.dart';

const _channel = MethodChannel('com.urban.callmemo/call_recording');

class CallRecordingOpenResult {
  const CallRecordingOpenResult({
    required this.opened,
    this.target,
    this.brand,
  });

  final bool opened;
  final String? target;
  final String? brand;

  factory CallRecordingOpenResult.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return const CallRecordingOpenResult(opened: false);
    }
    return CallRecordingOpenResult(
      opened: map['opened'] == true,
      target: map['target'] as String?,
      brand: map['brand'] as String?,
    );
  }
}

class CallRecordingDeviceInfo {
  const CallRecordingDeviceInfo({
    required this.rawBrand,
    required this.family,
  });

  final String rawBrand;
  final PhoneBrandFamily family;
}

/// Открытие системных настроек записи + тексты шагов по бренду.
class CallRecordingSetupService {
  CallRecordingSetupService._();
  static final CallRecordingSetupService instance = CallRecordingSetupService._();

  CallRecordingDeviceInfo? _cached;

  Future<CallRecordingDeviceInfo> detectDevice() async {
    if (_cached != null) return _cached!;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return _cached = const CallRecordingDeviceInfo(
        rawBrand: 'unknown',
        family: PhoneBrandFamily.unknown,
      );
    }
    final android = await DeviceInfoPlugin().androidInfo;
    final raw = android.brand.isNotEmpty ? android.brand : android.manufacturer;
    return _cached = CallRecordingDeviceInfo(
      rawBrand: raw,
      family: PhoneBrand.detect(raw),
    );
  }

  Future<CallRecordingOpenResult> openAutoRecordSettings() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return const CallRecordingOpenResult(opened: false);
    }
    final info = await detectDevice();
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'openAutoRecordSettings',
        {'brand': info.rawBrand},
      );
      return CallRecordingOpenResult.fromMap(result);
    } on PlatformException {
      return const CallRecordingOpenResult(opened: false);
    }
  }

  Future<CallRecordingOpenResult> openPhoneApp() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return const CallRecordingOpenResult(opened: false);
    }
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'openPhoneApp',
      );
      return CallRecordingOpenResult.fromMap(result);
    } on PlatformException {
      return const CallRecordingOpenResult(opened: false);
    }
  }

  String stepsFor(AppLocalizations l10n, PhoneBrandFamily family) =>
      switch (family) {
        PhoneBrandFamily.samsung => l10n.callRecordingStepsSamsung,
        PhoneBrandFamily.xiaomi => l10n.callRecordingStepsXiaomi,
        PhoneBrandFamily.oppo => l10n.callRecordingStepsOppo,
        PhoneBrandFamily.vivo => l10n.callRecordingStepsVivo,
        PhoneBrandFamily.tecno => l10n.callRecordingStepsTecno,
        PhoneBrandFamily.huawei => l10n.callRecordingStepsHuawei,
        PhoneBrandFamily.google => l10n.callRecordingStepsGoogle,
        PhoneBrandFamily.motorola => l10n.callRecordingStepsMotorola,
        PhoneBrandFamily.nothing => l10n.callRecordingStepsNothing,
        PhoneBrandFamily.sony => l10n.callRecordingStepsSony,
        PhoneBrandFamily.asus => l10n.callRecordingStepsAsus,
        PhoneBrandFamily.nokia => l10n.callRecordingStepsNokia,
        PhoneBrandFamily.unknown => l10n.callRecordingStepsGeneric,
      };
}
