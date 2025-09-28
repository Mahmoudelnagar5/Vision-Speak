import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  TTSService() {
    _initializeTts();
  }

  void _initializeTts() async {
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  /// Speak the provided text
  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  /// Dispose of the TTS service
  void dispose() {
    // FlutterTts doesn't have a dispose method, but we can stop any ongoing speech
    _flutterTts.stop();
  }
}
