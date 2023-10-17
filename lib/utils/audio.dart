import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class GameSounds {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _fireworksPlayer = AudioPlayer();

  void playWoosh() async {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;
    try {
      if (!isPlaying) {
        _audioPlayer.play(AssetSource("woosh.mp3"));
        bool result = _audioPlayer.state == PlayerState.playing;
        if (result) {
          isPlaying = true;
        }
      }
    } catch (e) {
      debugPrint("Error playing woosh sound: $e");
    }
  }

  void playMagicalSlice() async {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;
    try {
      if (!isPlaying) {
        _audioPlayer.play(AssetSource("magicalSlice2.mp3"));
        bool result = _audioPlayer.state == PlayerState.playing;
        if (result) {
          isPlaying = true;
        }
      }
    } catch (e) {
      debugPrint("Error playing start sound: $e");
    }
  }

  void playFireworks() async {
    bool isPlaying = _fireworksPlayer.state == PlayerState.playing;

    try {
      if (!isPlaying) {
        _fireworksPlayer.play(AssetSource('fireworks.mp3'));
        bool result = _fireworksPlayer.state == PlayerState.playing;
        if (result) {
          isPlaying = true;
        }
      }
    } catch (e) {
      debugPrint("Error playing wedgie sound: $e");
    }
  }

  void stopGameSound() {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;
    bool isFireworks = _fireworksPlayer.state == PlayerState.playing;
    if (isPlaying || isFireworks) {
      _audioPlayer.stop();
      _fireworksPlayer.stop();
    }
  }

  void disposeGameSound() {
    _audioPlayer.dispose();
    _fireworksPlayer.dispose();
  }
}
