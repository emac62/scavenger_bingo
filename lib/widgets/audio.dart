import 'package:audioplayers/audioplayers.dart';

AudioPlayer player = AudioPlayer();

void playSound(String fileName) async {
  await player.setSource(AssetSource(fileName));
  await player.play(AssetSource(fileName));
}

void stopSound() async {
  await player.stop();
}
