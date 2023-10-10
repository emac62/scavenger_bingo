import 'package:audioplayers/audioplayers.dart';

AudioPlayer player = AudioPlayer();

void playSound(String fileName) async {
  bool isPlaying = player.state == PlayerState.playing;
  if (!isPlaying) {
    await player.setSource(AssetSource(fileName));
    await player.play(AssetSource(fileName));
  }
}

void stopSound() async {
  bool isPlaying = player.state == PlayerState.playing;
  if (isPlaying) {
    await player.stop();
  }
}
