import 'package:flutter/material.dart';
import 'mixer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF071A2B),
              Color(0xFF123C46),
              Color(0xFF102D31),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.spa_rounded,
                      color: Color(0xFF8DE3D0),
                      size: 32,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'MindScape',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.self_improvement_rounded,
                  size: 92,
                  color: Color(0xFF8DE3D0),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Find your quiet place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Blend calming nature sounds with binaural beats for meditation, focus, relaxation, and sleep.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'How do you want to feel?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    MoodChip(
                      icon: Icons.self_improvement,
                      label: 'Calm',
                    ),
                    MoodChip(
                      icon: Icons.bedtime_rounded,
                      label: 'Sleep',
                    ),
                    MoodChip(
                      icon: Icons.center_focus_strong,
                      label: 'Focus',
                    ),
                    MoodChip(
                      icon: Icons.auto_awesome,
                      label: 'Create',
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 58,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MixerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text(
                      'Start Session',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF75D8C4),
                      foregroundColor: const Color(0xFF06211F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoodChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const MoodChip({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 19,
            color: const Color(0xFF8DE3D0),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}