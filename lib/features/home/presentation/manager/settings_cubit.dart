import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void setLanguage(String language) {
    String ocrLanguage = language == 'ar-SA' ? 'ara' : 'eng';
    emit(state.copyWith(language: language, ocrLanguage: ocrLanguage));
  }

  void setSpeechRate(double rate) {
    emit(state.copyWith(speechRate: rate));
  }
}
