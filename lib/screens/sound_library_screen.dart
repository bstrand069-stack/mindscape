import 'package:flutter/material.dart';

class SoundLibraryScreen extends StatelessWidget {
  const SoundLibraryScreen({super.key, this.activeSounds = const <String>{}});

  final Set<String> activeSounds;

  @override
  Widget build(BuildContext context) {
    final natureSounds = [
      ('Rain', Icons.water_drop_rounded),
      ('Ocean', Icons.waves_rounded),
      ('Thunder', Icons.thunderstorm_rounded),
      ('Forest', Icons.forest_rounded),
      ('Fireplace', Icons.local_fire_department_rounded),
      ('Wind', Icons.air_rounded),
      ('Stream', Icons.water_rounded),
      ('Night', Icons.nightlight_round),
    ];

    final meditationSounds = [
      ('Singing Bowls', Icons.music_note_rounded),
      ('Chimes', Icons.notifications_active_rounded),
      ('Temple Bells', Icons.notifications_rounded),
    ];

    final noiseSounds = [
      ('White Noise', Icons.graphic_eq_rounded),
      ('Pink Noise', Icons.graphic_eq_rounded),
      ('Brown Noise', Icons.graphic_eq_rounded),
      ('Green Noise', Icons.graphic_eq_rounded),
      ('Blue Noise', Icons.graphic_eq_rounded),
    ];

    Widget buildSoundTile((String, IconData) sound) {
      final isActive = activeSounds.contains(sound.$1);

      return ListTile(
        enabled: !isActive,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        tileColor: Colors.white.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        leading: Icon(
          sound.$2,
          color: isActive ? Colors.white38 : const Color(0xFF82E5D4),
        ),
        title: Text(
          sound.$1,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white38 : null,
          ),
        ),
        subtitle: isActive ? const Text('Already added') : null,
        trailing: Icon(
          isActive
              ? Icons.check_circle_rounded
              : Icons.add_circle_outline_rounded,
          color: isActive ? Colors.white38 : const Color(0xFF82E5D4),
        ),
        onTap: isActive
            ? null
            : () {
                Navigator.pop(context, sound.$1);
              },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF061922),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add Sound'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
        children: [
          const Text(
            'Nature',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          for (final sound in natureSounds) ...[
            buildSoundTile(sound),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 14),
          const Text(
            'Meditation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          for (final sound in meditationSounds) ...[
            buildSoundTile(sound),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 14),
          const Text(
            'Colored Noise',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          for (final sound in noiseSounds) ...[
            buildSoundTile(sound),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
