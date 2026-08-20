import 'package:flutter/material.dart';
import 'mixer_screen.dart';

class PresetScreen extends StatelessWidget {
  const PresetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03131F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Presets'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Presets',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView(
                  children: [
                    _PresetCard(
                      title: 'Deep Sleep',
                      subtitle: 'Rain, Brown Noise',
                      duration: '08:00:00',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const MixerScreen(presetName: 'Deep Sleep'),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    _PresetCard(
                      title: 'Morning Focus',
                      subtitle: 'Forest, Alpha Beat',
                      duration: '01:00:00',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const MixerScreen(presetName: 'Morning Focus'),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    _PresetCard(
                      title: 'Meditation Flow',
                      subtitle: 'Stream, Theta Beat',
                      duration: '00:45:00',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => 
                            const MixerScreen(presetName: 'Meditation Flow',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ); // Scaffold
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10283A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF29485C)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.graphic_eq_rounded,
            color: Color(0xFF82E5D4),
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8FA6B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            duration,
            style: const TextStyle(fontSize: 13, color: Color(0xFF8FA6B8)),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Color(0xFF82E5D4),
            ),
          ),
        ],
      ),
    );
  }
}
