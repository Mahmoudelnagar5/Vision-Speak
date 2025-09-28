import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum PlaybackState { playing, paused, stopped }

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  TtsService._internal();

  late FlutterTts flutterTts;
  bool isInitialized = false;
  PlaybackState _playbackState = PlaybackState.stopped;
  String _currentText = '';
  double _currentRate = 0.5;
  final String _currentLanguage = 'en-US'; // Default language is English

  // Notifiers for UI updates
  final ValueNotifier<PlaybackState> playbackStateNotifier = ValueNotifier(
    PlaybackState.stopped,
  );
  final ValueNotifier<double> speechRateNotifier = ValueNotifier(0.5);
  final ValueNotifier<double> progressNotifier = ValueNotifier(0.0);
  final ValueNotifier<Duration> currentTimeNotifier = ValueNotifier(
    Duration.zero,
  );
  final ValueNotifier<Duration> totalTimeNotifier = ValueNotifier(
    Duration.zero,
  );

  Future<void> initialize() async {
    if (isInitialized) return;

    try {
      flutterTts = FlutterTts();

      // Configure TTS settings with error handling
      await _configureTtsSettings();

      // Set up completion handler
      flutterTts.setCompletionHandler(() {
        _playbackState = PlaybackState.stopped;
        playbackStateNotifier.value = PlaybackState.stopped;
        progressNotifier.value = 1.0;
        currentTimeNotifier.value = totalTimeNotifier.value;
      });

      isInitialized = true;
    } catch (e) {
      print('Error initializing TTS Service: $e');
      isInitialized = false;
    }
  }

  Future<void> _configureTtsSettings() async {
    try {
      await flutterTts.setLanguage(_currentLanguage);
      await flutterTts.setSpeechRate(_currentRate);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      // Set initial notifier values
      speechRateNotifier.value = _currentRate;
    } catch (e) {
      print('Error configuring TTS settings: $e');
      // Try with fallback settings
      try {
        await flutterTts.setLanguage('en-US');
        await flutterTts.setSpeechRate(0.5);
      } catch (fallbackError) {
        print('Fallback TTS configuration also failed: $fallbackError');
      }
    }
  }

  PlaybackState get playbackState => _playbackState;

  Future<void> speak(String text) async {
    if (!isInitialized) {
      await initialize();
      if (!isInitialized) {
        print('TTS Service failed to initialize');
        return;
      }
    }

    try {
      _currentText = text;
      await flutterTts.speak(text);
      _playbackState = PlaybackState.playing;
      playbackStateNotifier.value = PlaybackState.playing;
      progressNotifier.value = 0.0;
      currentTimeNotifier.value = Duration.zero;
      // Estimate total time based on text length and speech rate
      final estimatedTime = Duration(
        seconds: (text.length / 15 * (1 / _currentRate)).round(),
      );
      totalTimeNotifier.value = estimatedTime;
    } catch (e) {
      print('Error speaking text: $e');
      _playbackState = PlaybackState.stopped;
      playbackStateNotifier.value = PlaybackState.stopped;
    }
  }

  Future<void> stop() async {
    if (!isInitialized) return;

    try {
      await flutterTts.stop();
      _playbackState = PlaybackState.stopped;
      playbackStateNotifier.value = PlaybackState.stopped;
      progressNotifier.value = 0.0;
      currentTimeNotifier.value = Duration.zero;
    } catch (e) {
      print('Error stopping TTS: $e');
    }
  }

  Future<void> pause() async {
    if (!isInitialized) return;

    try {
      await flutterTts.pause();
      _playbackState = PlaybackState.paused;
      playbackStateNotifier.value = PlaybackState.paused;
    } catch (e) {
      print('Error pausing TTS: $e');
    }
  }

  Future<void> resume() async {
    if (!isInitialized) return;

    if (_currentText.isNotEmpty && _playbackState == PlaybackState.paused) {
      try {
        await flutterTts.speak(_currentText);
        _playbackState = PlaybackState.playing;
        playbackStateNotifier.value = PlaybackState.playing;
      } catch (e) {
        print('Error resuming TTS: $e');
        _playbackState = PlaybackState.stopped;
        playbackStateNotifier.value = PlaybackState.stopped;
      }
    }
  }

  Future<void> setSpeechRate(double rate) async {
    if (!isInitialized) return;

    try {
      _currentRate = rate.clamp(0.1, 1.0);
      await flutterTts.setSpeechRate(_currentRate);
      speechRateNotifier.value = _currentRate;
    } catch (e) {
      print('Error setting speech rate: $e');
    }
  }

  // Language is fixed to English (en-US) for simplicity
  String get currentLanguage => _currentLanguage;

  Future<void> togglePlayback(String text) async {
    if (text.isEmpty) {
      return;
    }

    try {
      // Use the playback state to determine what to do
      if (_playbackState == PlaybackState.playing) {
        await pause();
      } else if (_playbackState == PlaybackState.paused) {
        await resume();
      } else {
        await speak(text);
      }
    } catch (e) {
      print('Error in toggle playback: $e');
      _playbackState = PlaybackState.stopped;
      playbackStateNotifier.value = PlaybackState.stopped;
    }
  }

  void dispose() {
    flutterTts.stop();
    playbackStateNotifier.dispose();
    speechRateNotifier.dispose();
    progressNotifier.dispose();
    currentTimeNotifier.dispose();
    totalTimeNotifier.dispose();
  }
}
