class SoundTrack {
  final String id;
  final String name;
  final String assetPath;
  final SoundCategory category;

  double volume;
  bool enabled;

  SoundTrack({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.category,
    this.volume = 0.5,
    this.enabled = false,
  });
}

enum SoundCategory {
  nature,
  binaural,
  isochronic,
}