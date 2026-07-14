class AppSettings {
  final bool autoTranscribe;
  final String themeMode;
  final String language;
  final String whisperModel;
  final bool notifyBeforeTranscribe;
  final String? userId;
  final String? authToken;

  const AppSettings({
    this.autoTranscribe = false,
    this.themeMode = 'system',
    this.language = 'ru',
    this.whisperModel = 'turbo',
    this.notifyBeforeTranscribe = true,
    this.userId,
    this.authToken,
  });

  factory AppSettings.defaults() => const AppSettings();

  AppSettings copyWith({
    bool? autoTranscribe,
    String? themeMode,
    String? language,
    String? whisperModel,
    bool? notifyBeforeTranscribe,
    String? userId,
    String? authToken,
  }) {
    return AppSettings(
      autoTranscribe: autoTranscribe ?? this.autoTranscribe,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      whisperModel: whisperModel ?? this.whisperModel,
      notifyBeforeTranscribe:
          notifyBeforeTranscribe ?? this.notifyBeforeTranscribe,
      userId: userId ?? this.userId,
      authToken: authToken ?? this.authToken,
    );
  }
}
