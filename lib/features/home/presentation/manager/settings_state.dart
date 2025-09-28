part of 'settings_cubit.dart';

class SettingsState {
  final String language;
  final String ocrLanguage;
  final double speechRate;

  const SettingsState({
    this.language = 'en-US',
    this.ocrLanguage = 'eng',
    this.speechRate = 0.5,
  });

  SettingsState copyWith({
    String? language,
    String? ocrLanguage,
    double? speechRate,
  }) {
    return SettingsState(
      language: language ?? this.language,
      ocrLanguage: ocrLanguage ?? this.ocrLanguage,
      speechRate: speechRate ?? this.speechRate,
    );
  }
}
