import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vision_speak/core/helper/functions/camera_functions.dart';

import '../../../../core/services/tts_service.dart';

class AudioPlaybackWidget extends StatefulWidget {
  final String textToSpeak;
  final String extractedText;

  const AudioPlaybackWidget({
    super.key,
    required this.textToSpeak,
    required this.extractedText,
  });

  @override
  State<AudioPlaybackWidget> createState() => _AudioPlaybackWidgetState();
}

class _AudioPlaybackWidgetState extends State<AudioPlaybackWidget> {
  final TtsService _ttsService = TtsService();
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _setupListeners();
  }

  @override
  void dispose() {
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
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
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
    // Audio playback area with dropdown
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Play button with TTS functionality
                GestureDetector(
                  onTap: () => _togglePlayback(widget.extractedText),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      _getPlayIcon(),
                      color: Colors.white,
                      size: 25.sp,
                    ),
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

                const SizedBox(width: 8),

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

                // Download button
                GestureDetector(
                  onTap: () =>
                      showSnackBar(context, 'Download feature coming soon!'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 25.sp,
                    ),
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

  void _showSpeedControlDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<double>(
          valueListenable: _ttsService.speechRateNotifier,
          builder: (context, currentRate, child) {
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
                    activeColor: Colors.blue,
                    value: currentRate.clamp(0.1, 1.0),
                    min: 0.1,
                    max: 1.0,
                    divisions: 18,
                    label: currentRate.toStringAsFixed(1),
                    onChanged: (double value) async {
                      try {
                        await _ttsService.setSpeechRate(value);
                      } catch (e) {
                        print('Error setting speech rate: $e');
                      }
                    },
                  ),
                  Text(
                    'Rate: ${currentRate.toStringAsFixed(1)}x',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
