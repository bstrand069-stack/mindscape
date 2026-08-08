import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class MixerScreen extends StatefulWidget {
  const MixerScreen({super.key});

  @override
  State<MixerScreen> createState() => _MixerScreenState();
}

class _MixerScreenState extends State<MixerScreen> {
  final AudioPlayer _rainPlayer = AudioPlayer();
  final AudioPlayer _thetaPlayer = AudioPlayer();

  double rain = 0.30;
  double theta = 0.15;

  bool playing = false;
  bool loading = true;
  String? audioError;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
  try {
    debugPrint('Loading rain...');

    final byteData =
    await rootBundle.load('assets/audio/nature/rain.mp3');

final tempDir = await getTemporaryDirectory();

final rainFile = File('${tempDir.path}/rain.mp3');

await rainFile.writeAsBytes(
  byteData.buffer.asUint8List(),
  flush: true,
);

await _rainPlayer.setFilePath(rainFile.path);

final thetaData =
    await rootBundle.load('assets/audio/binaural/theta.wav');

final thetaFile = File('${tempDir.path}/theta.wav');

await thetaFile.writeAsBytes(
  thetaData.buffer.asUint8List(),
  flush: true,
);

await _thetaPlayer.setFilePath(thetaFile.path);

await _thetaPlayer.setLoopMode(LoopMode.one);
await _thetaPlayer.setVolume(theta);

    await _rainPlayer.setLoopMode(LoopMode.one);
    await _rainPlayer.setVolume(rain);

    debugPrint('Rain loaded successfully');

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  } catch (e) {
    debugPrint('AUDIO ERROR: $e');

    if (!mounted) return;

    setState(() {
      loading = false;
      audioError = e.toString();
    });
  }
}

  Future<void> _togglePlayback() async {
  if (loading || audioError != null) return;

  try {
    if (playing) {
      await _rainPlayer.pause();
      await _thetaPlayer.pause();

      if (!mounted) return;

      setState(() {
        playing = false;
      });

      debugPrint('Audio paused');
    } else {
      if (!mounted) return;

      setState(() {
        playing = true;
      });

      debugPrint('Starting rain + theta');

      _rainPlayer.play();
      _thetaPlayer.play();
    }
  } catch (e) {
    debugPrint('PLAYBACK ERROR: $e');

    if (!mounted) return;

    setState(() {
      playing = false;
    });
  }
}

  Future<void> _setRainVolume(double value) async {
    setState(() {
      rain = value;
    });

    await _rainPlayer.setVolume(value);
  }

  Future<void> _setThetaVolume(double value) async {
    setState(() {
      theta = value;
    });

    await _thetaPlayer.setVolume(value);
  }

  @override
  void dispose() {
    _rainPlayer.dispose();
    _thetaPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081C27),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Sound Mixer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              'Rain + Theta',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (loading)
              const Text(
                'Loading audio...',
              ),

            if (audioError != null)
              Text(
                'Audio error:\n$audioError',
                style: const TextStyle(
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rain',
                style: TextStyle(fontSize: 18),
              ),
            ),

            Slider(
              value: rain,
              onChanged: _setRainVolume,
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Theta Beat',
                style: TextStyle(fontSize: 18),
              ),
            ),

            Slider(
              value: theta,
              onChanged: _setThetaVolume,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: FilledButton.icon(
                onPressed:
                    loading || audioError != null
                    ? null
                    : _togglePlayback,
                icon: Icon(
                  playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                label: Text(
                  playing
                      ? 'Pause Session'
                      : 'Begin Session',
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}