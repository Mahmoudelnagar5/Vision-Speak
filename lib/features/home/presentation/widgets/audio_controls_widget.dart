import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_speak/core/utils/app_colors.dart';

import 'package:vision_speak/core/services/tts_service.dart';
import '../manager/settings_cubit.dart';

class AudioControlsWidget extends StatefulWidget {
  final String extractedText;

  const AudioControlsWidget({super.key, required this.extractedText});

  @override
  State<AudioControlsWidget> createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
  final TTSService _ttsService = TTSService();

  final Map<double, String> speechRates = {
    0.25: 'Very Slow',
    0.5: 'Normal',
    0.75: 'Fast',
    1.0: 'Very Fast',
  };

  String? selectedRate;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
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
        );
      },
    );
  }
}
