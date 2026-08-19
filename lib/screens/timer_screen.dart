import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int selectedMinutes = 60;
  bool fadeOutEnabled = true;
  bool chimeEnabled = true;
  int remainingSeconds = 0;
  bool isRunning = false;
  Timer? sessionTimer;
  void _startTimer() {
    sessionTimer?.cancel();

    setState(() {
      remainingSeconds = selectedMinutes * 60;
      isRunning = true;
    });

    sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          remainingSeconds = 0;
          isRunning = false;
        });
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03131F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Timer'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Session Length',
                style: TextStyle(fontSize: 16, color: Color(0xFF8FA6B8)),
              ),
              const SizedBox(height: 12),
              Text(
                isRunning
                    ? '${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}'
                    : '$selectedMinutes min',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final minutes in [15, 30, 45, 60, 90])
                    ChoiceChip(
                      label: Text('$minutes min'),
                      selected: selectedMinutes == minutes,
                      selectedColor: const Color(0xFF249B84),
                      backgroundColor: const Color(0xFF0D2233),
                      onSelected: (_) {
                        setState(() {
                          selectedMinutes = minutes;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10283A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF29485C)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fade Out',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Gradually lower volume',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8FA6B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: fadeOutEnabled,
                      onChanged: (value) {
                        setState(() {
                          fadeOutEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10283A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF29485C)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chime',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Play sound at the end',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8FA6B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: chimeEnabled,
                      onChanged: (value) {
                        setState(() {
                          chimeEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF75D98B),
                        Color(0xFF65D4B1),
                        Color(0xFF58AFCB),
                        Color(0xFF7567C7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: FilledButton.icon(
                    onPressed: _startTimer,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text(
                      'Start Session',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: const Color(0xFF05201D),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
