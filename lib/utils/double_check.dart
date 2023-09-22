import 'package:hive/hive.dart';
import 'package:scavenger_hunt_bingo/data/bingo_card.dart';

checkNewName(String newName) {
  bool isCardNameNew = true;
  final cardBox = Hive.box<BingoCard>('cards');
  for (var i = 0; i < cardBox.length; i++) {
    final bingoCard = cardBox.get(i) as BingoCard;
    if (bingoCard.name == newName) {
      isCardNameNew = false;
    }
  }
  return isCardNameNew;
}
