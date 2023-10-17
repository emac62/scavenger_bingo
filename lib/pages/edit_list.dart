import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/data/free_cards.dart';
import 'package:scavenger_hunt_bingo/data/set_random_list.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
import 'package:scavenger_hunt_bingo/pages/settings.dart';
import 'package:scavenger_hunt_bingo/utils/double_check.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';

import '../data/bingo_card.dart';

class EditList extends StatefulWidget {
  const EditList({Key? key, required this.name}) : super(key: key);
  final BingoCard name;

  @override
  State<EditList> createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  late List<String> listToEdit;
  late String cardName;
  late int boxIndex;

  Box cardBox = Hive.box<BingoCard>('cards');

  void deleteItem(index) {
    setState(() {
      listToEdit.removeAt(index);
    });
  }

  showChangeNameDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.yellow[50],
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue, width: 5),
            borderRadius: BorderRadius.circular(15)),
        title: new Text(
          'This Card needs a new name!',
          style: TextStyle(color: Colors.purple, fontFamily: "CaveatBrush"),
        ),
        content: Text(
          'Please scroll to the top and change the name of your card.',
          style: TextStyle(color: Colors.purple),
        ),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(); // dismisses only the dialog and returns nothing
            },
            child: new Text('OK'),
          ),
        ],
      ),
    );
  }

  showDuplicateDialog(BuildContext context, String entry) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.yellow[50],
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue, width: 5),
            borderRadius: BorderRadius.circular(15)),
        title: new Text(
          'Duplicate Entry',
          style: TextStyle(color: Colors.purple, fontFamily: "CaveatBrush"),
        ),
        content: Text(
          'This $entry is already used.',
          style: TextStyle(color: Colors.purple),
        ),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(); // dismisses only the dialog and returns nothing
            },
            child: new Text('OK'),
          ),
        ],
      ),
    );
  }

  void editItem(String item, int index) {
    //check for item already in listToEdit
    if (listToEdit.contains(item)) {
      showDuplicateDialog(context, "item");
    } else {
      setState(() {
        listToEdit[index] = item;
        _controller.clear();
      });
    }
  }

  void showEditDialogue(context, item, index) {
    showDialog(
        context: context,
        builder: (context) {
          _controller.text = listToEdit[index].toLowerCase();

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    border: Border.all(color: Colors.blue, width: 5),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _controller,
                        autofocus: true,
                        maxLength: 24,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          hintText: listToEdit[index].toLowerCase(),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2),
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.yellow[50]),
                              child: const Text('Save',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                editItem(_controller.text, index);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.yellow[50]),
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                _controller.clear();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showNameDialogue(BuildContext context, SettingsProvider settings) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    border: Border.all(color: Colors.blue, width: 5),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        maxLength: 24,
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
                        ),
                        decoration: const InputDecoration(
                          hintText: "where are these items",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2),
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.yellow[50]),
                              child: const Text('Save',
                                  style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                if (checkNewName(_nameController.text)) {
                                  List<String> purchasedCards =
                                      settings.purchasedCards as List<String>;
                                  List<String> createdCards =
                                      settings.createdCards as List<String>;

                                  String newCardName = _nameController.text;
                                  createdCards.remove(cardName);

                                  purchasedCards.add(newCardName);

                                  setState(() {
                                    settings.setCreatedCards(createdCards);

                                    settings.setPurchasedCards(purchasedCards);
                                    cardName = newCardName;

                                    cardBox.putAt(boxIndex,
                                        BingoCard(cardName, true, listToEdit));
                                    settings.setBoard(cardName);
                                    _nameController.clear();
                                  });
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  Navigator.pop(context);
                                } else {
                                  showDuplicateDialog(context, "name");
                                }
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white),
                              child: const Text('Cancel',
                                  style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                _nameController.clear();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showAddDialogue(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    border: Border.all(color: Colors.blue, width: 5),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _addController,
                        autofocus: true,
                        maxLength: 24,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        decoration: const InputDecoration(
                          hintText: "new item",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2),
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white),
                              child: const Text('Add',
                                  style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                if (!listToEdit.contains(_addController.text)) {
                                  setState(() {
                                    listToEdit.add(_addController.text);
                                    _addController.clear();
                                  });

                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  Navigator.pop(context);
                                } else {
                                  showDuplicateDialog(context, "item");
                                }
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white),
                              child: const Text('Cancel',
                                  style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                _addController.clear();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    final bingoCard = widget.name;
    cardName = bingoCard.name;
    listToEdit = bingoCard.items;
    boxIndex = bingoCard.key;
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _addController.dispose();
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  getResourceList(String name) {
    Box cardBox = Hive.box<BingoCard>('cards');

    final bingoCard =
        cardBox.values.where((card) => card.name == name).toList();
    cardName = bingoCard[0].name;
    listToEdit = bingoCard[0].items;
    boxIndex = bingoCard[0].key;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var settings = Provider.of<SettingsProvider>(context, listen: true);
    return Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "$cardName: ${listToEdit.length} items",
            style: TextStyle(
                fontFamily: "CaveatBrush",
                fontSize: SizeConfig.blockSizeVertical * 3.5),
          ),
          toolbarHeight: SizeConfig.blockSizeVertical * 7,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
            ),
          ),
          actions: [
            !freeTextCards.contains(cardName)
                ? IconButton(
                    onPressed: (() => showNameDialogue(context, settings)),
                    icon: Icon(Icons.edit))
                : SizedBox()
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: <Widget>[
              cardName.contains("My Card")
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(15)),
                            disabledBackgroundColor: Theme.of(context)
                                .primaryColor
                                .withOpacity(.8), // Background Color
                            disabledForegroundColor:
                                Colors.yellow[50], //Text Color
                          ),
                          onPressed: () {
                            showNameDialogue(context, settings);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Give your card a name",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.edit,
                                size: 16,
                              )
                            ],
                          )),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  listToEdit.length < 35
                      ? "Edit any of the items below or scroll to the bottom to add more. Each list must have a minimum of 25 and a maximum of 35 items."
                      : "This list has the maximum of 35 items. Each item below can be edited.",
                  style: const TextStyle(fontSize: 16, color: Colors.purple),
                  textAlign: TextAlign.center,
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 7 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: listToEdit.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return itemToEdit(index);
                  }),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 5,
                    vertical: SizeConfig.blockSizeVertical * 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    listToEdit.length < 35
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                        color: Colors.blue, width: 3))),
                            onPressed: () {
                              showAddDialogue(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Add another item",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3,
                                    color: Colors.yellow[50],
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        : const SizedBox(
                            height: 0,
                          ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side:
                                    BorderSide(color: Colors.blue, width: 3))),
                        onPressed: () {
                          debugPrint("Save and Play called");
                          setState(() {
                            final cardBox = Hive.box<BingoCard>("cards");
                            cardBox.putAt(boxIndex,
                                BingoCard(cardName, true, listToEdit));
                            settings.setBoard(cardName);
                            setRandomList(context, cardName);
                            debugPrint("cardBox length: ${cardBox.length}");
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Save and Play",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3,
                                color: Colors.yellow[50],
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget itemToEdit(index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        border: Border.all(width: 1.5, color: Colors.blue),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "${index + 1}",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                listToEdit[index].toLowerCase(),
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                showEditDialogue(
                    context, listToEdit[index].toLowerCase(), index);
              },
              child: Icon(
                Icons.edit,
                color: Colors.purple,
                size: 16,
              )),
          listToEdit.length > 25
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                      onTap: () {
                        deleteItem(index);
                      },
                      child:
                          Icon(Icons.delete, color: Colors.purple, size: 16)),
                )
              : SizedBox(
                  width: 25,
                ),
        ],
      ),
    );
  }
}
