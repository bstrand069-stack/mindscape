import 'sound_library_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/sound_track.dart';
import '../services/audio_service.dart';
import '../services/tone_generator.dart';

class MixerScreen extends StatefulWidget {
  const MixerScreen({super.key});

  @override
  State<MixerScreen> createState() => _MixerScreenState();
}

class _MixerScreenState extends State<MixerScreen> {
  final AudioService _audioService = AudioService();
  final ToneGenerator _toneGenerator = ToneGenerator();
  final AudioPlayer _tonePlayer = AudioPlayer();

  final List<SoundTrack> activeTracks = [];

  bool loading = true;
  bool playing = false;
  bool toneUpdating = false;
  String? audioError;

  String toneType = 'Binaural';
  String brainwave = 'Theta';

  double carrierPitch = 200;
  double toneVolume = 0.15;
  double beatHz = 6.0;
  double masterVolume = 1.0;

  @override
  void initState() {
    super.initState();

    activeTracks.add(
      SoundTrack(
        id: 'rain',
        name: 'Rain',
        assetPath: 'assets/audio/nature/rain.mp3',
        category: SoundCategory.nature,
        volume: 0.30,
        enabled: true,
      ),
    );

    _loadAudio();
  }

  double get beatFrequency => beatHz;

  ToneMode get toneMode {
    return toneType == 'Isochronic' ? ToneMode.isochronic : ToneMode.binaural;
  }

  Future<void> _loadAudio() async {
    try {
      for (final track in activeTracks) {
        await _audioService.loadTrack(track);
      }
      await _generateTone();

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        audioError = e.toString();
      });
    }
  }

  Future<void> _generateTone() async {
    if (toneType == 'None') {
      await _tonePlayer.pause();
      return;
    }

    if (mounted) {
      setState(() {
        toneUpdating = true;
      });
    }

    final wasPlaying = playing;

    await _tonePlayer.pause();

    final toneFile = await _toneGenerator.generate(
      mode: toneMode,
      carrierHz: carrierPitch,
      beatHz: beatFrequency,
      durationSeconds: 10,
    );

    await _tonePlayer.setFilePath(toneFile.path);
    await _tonePlayer.setLoopMode(LoopMode.one);
    await _tonePlayer.setVolume(toneVolume);

    if (wasPlaying) {
      _tonePlayer.play();
    }

    if (!mounted) return;

    setState(() {
      toneUpdating = false;
    });
  }

  Future<void> _togglePlayback() async {
    if (loading || audioError != null || toneUpdating) {
      return;
    }

    if (playing) {
      for (final track in activeTracks) {
        await _audioService.pauseTrack(track.id);
      }

      await _tonePlayer.pause();

      if (!mounted) return;

      setState(() {
        playing = false;
      });
    } else {
      for (final track in activeTracks) {
        _audioService.playTrack(track.id);
      }

      if (toneType != 'None') {
        _tonePlayer.play();
      }

      if (!mounted) return;

      setState(() {
        playing = true;
      });
    }
  }

  Future<void> _setTrackVolume(SoundTrack track, double value) async {
    setState(() {
      track.volume = value;
    });

    await _audioService.setVolume(track.id, value * masterVolume);
  }

  Future<void> _setToneVolume(double value) async {
    setState(() {
      toneVolume = value;
    });

    await _tonePlayer.setVolume(value * masterVolume);
  }

  Future<void> _changeToneType(String value) async {
    setState(() {
      toneType = value;
    });

    await _generateTone();
  }

  Future<void> _changeCarrierPitch(double value) async {
    setState(() {
      carrierPitch = value;
    });
  }

  Future<void> _finishCarrierPitchChange(double value) async {
    carrierPitch = value;
    await _generateTone();
  }

  Future<void> _changeBrainwave(String value) async {
    double defaultFrequency;

    switch (value) {
      case 'Delta':
        defaultFrequency = 2.0;
        break;
      case 'Theta':
        defaultFrequency = 6.0;
        break;
      case 'Alpha':
        defaultFrequency = 10.0;
        break;
      case 'Beta':
        defaultFrequency = 18.0;
        break;
      case 'Gamma':
        defaultFrequency = 40.0;
        break;
      default:
        defaultFrequency = 6.0;
    }

    setState(() {
      brainwave = value;
      beatHz = defaultFrequency;
    });

    await _generateTone();
  }

  Future<void> _addSound(String name) async {
    final soundMap = <String, SoundTrack>{
      'Rain': SoundTrack(
        id: 'rain',
        name: 'Rain',
        assetPath: 'assets/audio/nature/rain.mp3',
        category: SoundCategory.nature,
        volume: 0.30,
        enabled: true,
      ),

      'Ocean': SoundTrack(
        id: 'ocean',
        name: 'Ocean',
        assetPath: 'assets/audio/nature/ocean.mp3',
        category: SoundCategory.nature,
        volume: 0.25,
        enabled: true,
      ),

      'Forest': SoundTrack(
        id: 'forest',
        name: 'Forest',
        assetPath: 'assets/audio/nature/forest.mp3',
        category: SoundCategory.nature,
        volume: 0.25,
        enabled: true,
      ),

      'Thunder': SoundTrack(
        id: 'thunder',
        name: 'Thunder',
        assetPath: 'assets/audio/nature/thunder.mp3',
        category: SoundCategory.nature,
        volume: 0.25,
        enabled: true,
      ),

      'Fireplace': SoundTrack(
        id: 'fireplace',
        name: 'Fireplace',
        assetPath: 'assets/audio/nature/fireplace.mp3',
        category: SoundCategory.nature,
        volume: 0.25,
        enabled: true,
      ),

      'Wind': SoundTrack(
        id: 'wind',
        name: 'Wind',
        assetPath: 'assets/audio/nature/wind.mp3',
        category: SoundCategory.nature,
        volume: 0.25,
        enabled: true,
      ),

      'Stream': SoundTrack(
        id: 'stream',
        name: 'Stream',
        assetPath: 'assets/audio/nature/stream.mp3',
        category: SoundCategory.nature,
        volume: 0.25,
        enabled: true,
      ),

      'Night': SoundTrack(
        id: 'night',
        name: 'Night',
        assetPath: 'assets/audio/nature/night.mp3',
        category: SoundCategory.nature,
        volume: 0.25,
        enabled: true,
      ),
    };

    final track = soundMap[name];

    if (track == null) {
      return;
    }

    if (activeTracks.any((existing) => existing.id == track.id)) {
      return;
    }

    try {
      await _audioService.loadTrack(track);

      if (playing) {
        _audioService.playTrack(track.id);
      }

      if (!mounted) return;

      setState(() {
        activeTracks.add(track);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load ${track.name}: $e')),
      );
    }
  }

  String get currentBrainwave {
    if (beatHz < 4.0) {
      return 'Delta';
    } else if (beatHz < 8.0) {
      return 'Theta';
    } else if (beatHz < 12.0) {
      return 'Alpha';
    } else if (beatHz < 30.0) {
      return 'Beta';
    } else {
      return 'Gamma';
    }
  }

  Future<void> _setMasterVolume(double value) async {
    setState(() {
      masterVolume = value;
    });

    for (final track in activeTracks) {
      await _audioService.setVolume(track.id, track.volume * masterVolume);
    }

    await _tonePlayer.setVolume(toneVolume * masterVolume);
  }

  @override
  void dispose() {
    _audioService.dispose();
    _tonePlayer.dispose();
    super.dispose();
  }

  Future<void> _removeExtraTrack(SoundTrack track) async {
    await _audioService.pauseTrack(track.id);

    if (!mounted) return;

    setState(() {
      activeTracks.removeWhere((existing) => existing.id == track.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061922),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('MindScape Mixer'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionCard(
                title: 'Brainwave Tone',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tone Type',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        _choiceChip('Binaural'),
                        _choiceChip('Isochronic'),
                        _choiceChip('None'),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Brainwave',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _brainwaveChip('Delta'),
                        _brainwaveChip('Theta'),
                        _brainwaveChip('Alpha'),
                        _brainwaveChip('Beta'),
                        _brainwaveChip('Gamma'),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Beat Frequency',

                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${beatFrequency.toStringAsFixed(1)} Hz',
                          style: const TextStyle(
                            color: Color(0xFF82E5D4),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    Slider(
                      min: 0.5,
                      max: 40.0,
                      divisions: 395,
                      value: beatHz,
                      onChanged: (value) {
                        setState(() {
                          beatHz = value;

                          if (value < 4.0) {
                            brainwave = 'Delta';
                          } else if (value < 8.0) {
                            brainwave = 'Theta';
                          } else if (value < 12.0) {
                            brainwave = 'Alpha';
                          } else if (value < 30.0) {
                            brainwave = 'Beta';
                          } else {
                            brainwave = 'Gamma';
                          }
                        });
                      },
                      onChangeEnd: (value) async {
                        beatHz = value;
                        await _generateTone();
                      },
                    ), // Slider

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Carrier Pitch',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${carrierPitch.round()} Hz',
                          style: const TextStyle(
                            color: Color(0xFF82E5D4),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      min: 100,
                      max: 400,
                      divisions: 30,
                      value: carrierPitch,
                      onChanged: _changeCarrierPitch,
                      onChangeEnd: _finishCarrierPitchChange,
                    ),
                    if (toneUpdating)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Updating tone...',
                              style: TextStyle(color: Colors.white60),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _sectionCard(
                title: 'Soundscape',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Master Volume',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${(masterVolume * 100).round()}%',
                          style: const TextStyle(
                            color: Color(0xFF82E5D4),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    Slider(value: masterVolume, onChanged: _setMasterVolume),

                    const SizedBox(height: 18),

                    for (final track in activeTracks) ...[
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _soundRow(
                              icon: switch (track.id) {
                                'rain' => Icons.water_drop_rounded,
                                'ocean' => Icons.waves_rounded,
                                'forest' => Icons.forest_rounded,
                                'thunder' => Icons.thunderstorm_rounded,
                                'fireplace' =>
                                  Icons.local_fire_department_rounded,
                                'wind' => Icons.air_rounded,
                                'stream' => Icons.water_rounded,
                                'night' => Icons.nightlight_round,
                                _ => Icons.graphic_eq_rounded,
                              },
                              name: track.name,
                              value: track.volume,
                              onChanged: (value) {
                                _setTrackVolume(track, value);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: 'Remove ${track.name}',
                            onPressed: () {
                              _removeExtraTrack(track);
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ],

                    _soundRow(
                      icon: Icons.graphic_eq_rounded,
                      name: toneType == 'None'
                          ? 'Tone Off'
                          : '$currentBrainwave $toneType',
                      value: toneVolume,
                      onChanged: _setToneVolume,
                    ),

                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final selectedSound = await Navigator.of(context)
                            .push<String>(
                              MaterialPageRoute(
                                builder: (_) => SoundLibraryScreen(
                                  activeSounds: activeTracks
                                      .map((track) => track.name)
                                      .toSet(),
                                ),
                              ),
                            );

                        if (selectedSound == null) return;
                        if (!context.mounted) return;

                        await _addSound(selectedSound);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Sound'),
                    ),
                  ],
                ), // Column
              ), // _sectionCard
              const SizedBox(height: 18),
              if (loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (audioError != null)
                Text(
                  'Audio error:\n$audioError',
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 10),
              SizedBox(
                height: 62,
                child: FilledButton.icon(
                  onPressed: loading || audioError != null || toneUpdating
                      ? null
                      : _togglePlayback,
                  icon: Icon(
                    playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    playing ? 'Pause Session' : 'Begin Session',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF78DCC8),
                    foregroundColor: const Color(0xFF05201D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
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

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _choiceChip(String label) {
    final selected = toneType == label;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        _changeToneType(label);
      },
    );
  }

  Widget _brainwaveChip(String label) {
    final selected = currentBrainwave == label;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: toneType == 'None'
          ? null
          : (_) {
              _changeBrainwave(label);
            },
    );
  }

  Widget _soundRow({
    required IconData icon,
    required String name,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF82E5D4)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: const TextStyle(color: Color(0xFF82E5D4)),
            ),
          ],
        ),
        Slider(value: value, onChanged: onChanged),
      ],
    );
  }
}
