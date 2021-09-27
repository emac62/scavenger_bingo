import 'package:audioplayers/audioplayers.dart';

AudioCache cache = new AudioCache();
AudioPlayer player = new AudioPlayer();

void playSound(String fileName) async {
  player = await cache.play(fileName);
}

void stopSound() async {
  player.stop();
}
