<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_speak/core/utils/app_colors.dart';

import 'package:vision_speak/core/services/tts_service.dart';
import '../manager/settings_cubit.dart';
=======
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vision_speak/core/services/tts_service.dart';
import 'package:vision_speak/core/utils/app_colors.dart';
>>>>>>> 14496e2386762b2b631720e97b01fe2715d3ad33

class AudioControlsWidget extends StatefulWidget {
  final String extractedText;

  const AudioControlsWidget({super.key, required this.extractedText});

  @override
  State<AudioControlsWidget> createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
<<<<<<< HEAD
  final TTSService _ttsService = TTSService();

  final Map<double, String> speechRates = {
    0.25: 'Very Slow',
    0.5: 'Normal',
    0.75: 'Fast',
    1.0: 'Very Fast',
  };

  String? selectedRate;
=======
  final TtsService _ttsService = TtsService();
  Timer? _progressTimer;
>>>>>>> 14496e2386762b2b631720e97b01fe2715d3ad33

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    final cubit = context.read<SettingsCubit>();
    selectedRate = selectedRateFromDouble(cubit.state.speechRate);
  }

  String selectedRateFromDouble(double rate) {
    if (rate >= 0 && rate < 0.5)
      return 'Very Slow';
    else if (rate >= 0.5 && rate < 0.75)
      return 'Normal';
    else if (rate >= 0.75 && rate < 1)
      return 'Fast';
    else
      return 'Very Fast';
  }

  double doubleFromSelectedRate(String rate) {
    switch (rate) {
      case 'Very Slow':
        return 0.25;
      case 'Normal':
        return 0.5;
      case 'Fast':
        return 0.75;
      case 'Very Fast':
        return 1.0;
      default:
        return 0.5;
    }
  }

  Future<void> _speakText() async {
    final cubit = context.read<SettingsCubit>();
    await _ttsService.setLanguage(cubit.state.language);
    await _ttsService.setSpeechRate(cubit.state.speechRate);
    await _ttsService.speak(widget.extractedText);
=======
    _initializeTts();
    _setupListeners();
>>>>>>> 14496e2386762b2b631720e97b01fe2715d3ad33
  }

  @override
  void dispose() {
<<<<<<< HEAD
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Audio Playback',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedRate,
                items: speechRates.values.map((rate) {
                  return DropdownMenuItem<String>(
                    value: rate,
                    child: Text(
                      rate,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedRate = value;
                    });
                    double rateValue = doubleFromSelectedRate(value);
                    context.read<SettingsCubit>().setSpeechRate(rateValue);
                  }
                },
                dropdownColor: const Color(0xFF1A1A1A),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 20,
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Play/Pause button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _speakText();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 24,
                      ),
                      label: const Text(
                        'Play',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Stop button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _ttsService.stop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkInactiveButtonColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: const Text(
                        'Stop',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
=======
    _stopProgressTimer();
    _ttsService.stop();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    try {
      await _ttsService.initialize();
    } catch (e) {
      print('Error initializing TTS in audio controls: $e');
    }
  }

  void _setupListeners() {
    _ttsService.playbackStateNotifier.addListener(_onPlaybackStateChanged);
    _ttsService.progressNotifier.addListener(_onProgressChanged);
    _ttsService.currentTimeNotifier.addListener(_onTimeChanged);
    _ttsService.speechRateNotifier.addListener(_onSpeechRateChanged);
  }

  void _onSpeechRateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onPlaybackStateChanged() {
    if (mounted) {
      setState(() {});
      _handleTimer();
    }
  }

  void _handleTimer() {
    if (_ttsService.playbackStateNotifier.value == PlaybackState.playing) {
      // Start timer to update progress
      _startProgressTimer();
    } else {
      // Stop timer
      _stopProgressTimer();
    }
  }

  void _startProgressTimer() {
    _stopProgressTimer(); // Stop any existing timer
    _progressTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted ||
          _ttsService.playbackStateNotifier.value != PlaybackState.playing) {
        _stopProgressTimer();
        return;
      }

      // Update current time and progress
      final currentTime = _ttsService.currentTimeNotifier.value;
      final totalTime = _ttsService.totalTimeNotifier.value;

      if (totalTime.inSeconds > 0) {
        final newTime = currentTime + const Duration(milliseconds: 100);
        final progress =
            newTime.inMilliseconds.toDouble() /
            totalTime.inMilliseconds.toDouble();

        if (progress >= 1.0) {
          // End of playback
          _ttsService.currentTimeNotifier.value = totalTime;
          _ttsService.progressNotifier.value = 1.0;
          _ttsService.playbackStateNotifier.value = PlaybackState.stopped;
        } else {
          _ttsService.currentTimeNotifier.value = newTime;
          _ttsService.progressNotifier.value = progress.clamp(0.0, 1.0);
        }
      }
    });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  void _onProgressChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onTimeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Play button with TTS functionality
          GestureDetector(
            onTap: () => _togglePlayback(widget.extractedText),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkScaffoldBgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(_getPlayIcon(), color: Colors.white, size: 25.sp),
            ),
          ),

          const SizedBox(width: 4),

          // Progress bar
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final progress = _ttsService.progressNotifier.value;
                final progressWidth = constraints.maxWidth * progress;
                return Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: progressWidth.w,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 4),

          // Speed control button
          GestureDetector(
            onTap: () => _showSpeedControlDialog(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.speed, color: Colors.white, size: 25.sp),
            ),
          ),

          const SizedBox(width: 4),

          // Stop button
          GestureDetector(
            onTap: () => _stopPlayback(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.stop, color: Colors.white, size: 25.sp),
            ),
          ),

          const SizedBox(width: 8),

          // Time display
          Text(
            _formatDuration(_ttsService.currentTimeNotifier.value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlayIcon() {
    return switch (_ttsService.playbackStateNotifier.value) {
      PlaybackState.playing => Icons.pause,
      PlaybackState.paused || PlaybackState.stopped => Icons.play_arrow,
    };
  }

  Future<void> _togglePlayback(String text) async {
    try {
      await _ttsService.togglePlayback(text);
    } catch (e) {
      print('Error in toggle playback: $e');
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await _ttsService.stop();
    } catch (e) {
      print('Error stopping playback: $e');
    }
  }

  void _showSpeedControlDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: const Text(
            'Speech Rate',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: _ttsService.speechRateNotifier.value,
                min: 0.1,
                max: 1.0,
                divisions: 18,
                label: _ttsService.speechRateNotifier.value.toStringAsFixed(1),
                onChanged: (double value) async {
                  try {
                    await _ttsService.setSpeechRate(value);
                  } catch (e) {
                    print('Error setting speech rate: $e');
                  }
                },
              ),
              Text(
                'Rate: ${_ttsService.speechRateNotifier.value.toStringAsFixed(1)}x',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.blue)),
            ),
          ],
>>>>>>> 14496e2386762b2b631720e97b01fe2715d3ad33
        );
      },
    );
  }
}
