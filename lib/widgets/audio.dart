import 'package:audioplayers/audioplayers.dart';

AudioPlayer player = AudioPlayer();

void playSound(String fileName) async {
  await player.setSource(AssetSource(fileName));
  await player.play(AssetSource(fileName));
  // if (fileName == "woosh.mov") {
  //   Future.delayed(const Duration(milliseconds: 750), () {
  //     player.stop();
  //   });
  // }
  // if (fileName == "magicalSlice.mov") {
  //   Future.delayed(const Duration(milliseconds: 1250), () {
  //     player.stop();
  //   });
  // }
}

void stopSound() async {
  await player.stop();
}
