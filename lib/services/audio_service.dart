import 'dart:io';

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../models/sound_track.dart';

class AudioService {
  final Map<String, AudioPlayer> _players = {};

  Future<void> loadTrack(SoundTrack track) async {
    if (_players.containsKey(track.id)) {
      return;
    }

    final byteData = await rootBundle.load(track.assetPath);

    final tempDir = await getTemporaryDirectory();

    final extension = track.assetPath.split('.').last;

    final localFile = File(
      '${tempDir.path}/${track.id}.$extension',
    );

    await localFile.writeAsBytes(
      byteData.buffer.asUint8List(),
      flush: true,
    );

    final player = AudioPlayer();

    await player.setFilePath(localFile.path);
    await player.setLoopMode(LoopMode.one);
    await player.setVolume(track.volume);

    _players[track.id] = player;
  }

  Future<void> playTrack(String id) async {
    final player = _players[id];

    if (player == null) return;

    player.play();
  }

  Future<void> pauseTrack(String id) async {
    final player = _players[id];

    if (player == null) return;

    await player.pause();
  }

  Future<void> setVolume(
    String id,
    double volume,
  ) async {
    final player = _players[id];

    if (player == null) return;

    await player.setVolume(volume);
  }

  Future<void> stopAll() async {
    for (final player in _players.values) {
      await player.pause();
      await player.seek(Duration.zero);
    }
  }

  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }

    _players.clear();
  }
}