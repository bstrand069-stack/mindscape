import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

enum ToneMode {
  binaural,
  isochronic,
}

class ToneGenerator {
  static const int sampleRate = 44100;
  static const int bitsPerSample = 16;
  static const int channels = 2;

  Future<File> generate({
    required ToneMode mode,
    required double carrierHz,
    required double beatHz,
    int durationSeconds = 10,
  }) async {
    final directory = await getTemporaryDirectory();

    final file = File(
      '${directory.path}/mindscape_generated_tone.wav',
    );

    final sampleCount = sampleRate * durationSeconds;
    final audioData = BytesBuilder();

    const amplitude = 0.18;

    for (int i = 0; i < sampleCount; i++) {
      final time = i / sampleRate;

      double left;
      double right;
      

      if (mode == ToneMode.binaural) {
        left = sin(
          2 * pi * carrierHz * time,
        );

        right = sin(
          2 * pi * (carrierHz + beatHz) * time,
        );
      } else {
        final carrier = sin(
          2 * pi * carrierHz * time,
        );

        // Smooth rhythmic pulse at the selected beat frequency.
        final pulse =
            (sin(2 * pi * beatHz * time) + 1) / 2;

        left = carrier * pulse;
        right = carrier * pulse;
      }

      // Tiny fade at the beginning/end helps prevent loop clicks.
      const fadeDuration = 0.02;
      final fadeSamples =
          (sampleRate * fadeDuration).round();

      double fade = 1.0;

      if (i < fadeSamples) {
        fade = i / fadeSamples;
      } else if (i >
          sampleCount - fadeSamples) {
        fade =
            (sampleCount - i) / fadeSamples;
      }

      left *= amplitude * fade;
      right *= amplitude * fade;

      final leftSample =
          (left * 32767).round().clamp(-32768, 32767);

      final rightSample =
          (right * 32767).round().clamp(-32768, 32767);

      audioData.add(
        Uint8List.fromList([
          leftSample & 0xff,
          (leftSample >> 8) & 0xff,
          rightSample & 0xff,
          (rightSample >> 8) & 0xff,
        ]),
      );
    }

    final pcm = audioData.toBytes();
    final wav = _createWavHeader(pcm.length);

    await file.writeAsBytes(
      [...wav, ...pcm],
      flush: true,
    );

    return file;
  }

  Uint8List _createWavHeader(int dataLength) {
    final header = ByteData(44);

    void writeText(
      int offset,
      String text,
    ) {
      for (int i = 0; i < text.length; i++) {
        header.setUint8(
          offset + i,
          text.codeUnitAt(i),
        );
      }
    }

    writeText(0, 'RIFF');

    header.setUint32(
      4,
      36 + dataLength,
      Endian.little,
    );

    writeText(8, 'WAVE');
    writeText(12, 'fmt ');

    header.setUint32(
      16,
      16,
      Endian.little,
    );

    header.setUint16(
      20,
      1,
      Endian.little,
    );

    header.setUint16(
      22,
      channels,
      Endian.little,
    );

    header.setUint32(
      24,
      sampleRate,
      Endian.little,
    );

    final byteRate =
        sampleRate *
        channels *
        bitsPerSample ~/
        8;

    header.setUint32(
      28,
      byteRate,
      Endian.little,
    );

    final blockAlign =
        channels *
        bitsPerSample ~/
        8;

    header.setUint16(
      32,
      blockAlign,
      Endian.little,
    );

    header.setUint16(
      34,
      bitsPerSample,
      Endian.little,
    );

    writeText(36, 'data');

    header.setUint32(
      40,
      dataLength,
      Endian.little,
    );

    return header.buffer.asUint8List();
  }
}