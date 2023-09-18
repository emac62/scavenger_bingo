import 'package:hive_flutter/hive_flutter.dart';

part 'bingo_card.g.dart';

@HiveType(typeId: 0)
class BingoCard extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final bool canEdit;
  @HiveField(2)
  final List<String> items;

  BingoCard(this.name, this.canEdit, this.items);
}
