import 'package:flutter/material.dart';

class SoundLibraryScreen extends StatelessWidget {
  const SoundLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sounds = [
      ('Rain', Icons.water_drop_rounded),
      ('Ocean', Icons.waves_rounded),
      ('Thunder', Icons.thunderstorm_rounded),
      ('Forest', Icons.forest_rounded),
      ('Fireplace', Icons.local_fire_department_rounded),
      ('Wind', Icons.air_rounded),
      ('Stream', Icons.water_rounded),
      ('Night', Icons.nightlight_round),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF061922),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add Sound'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: sounds.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final sound = sounds[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            tileColor:
                Colors.white.withValues(alpha: 0.06),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color:
                    Colors.white.withValues(alpha: 0.08),
              ),
            ),
            leading: Icon(
              sound.$2,
              color: const Color(0xFF82E5D4),
            ),
            title: Text(
              sound.$1,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.add_circle_outline_rounded,
            ),
            onTap: () {
              Navigator.pop(context, sound.$1);
            },
          );
        },
      ),
    );
  }
}